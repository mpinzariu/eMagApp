////
////  EmagAPIRequest2.swift
////  TestTableViewApp2
////
////  Created by Pinzariu Marian on 02/05/2018.
////  Copyright © 2018 Pinzariu Marian. All rights reserved.
////

import Foundation
import SwiftSoup

public class EmagAPIRequest: NSObject {
    open let requestType: String = ""

    private var requestValue: String?

    private var document: Document = Document.init("")

    var products = [Array<Product>]()

    public func searchForProducts(searchValue: String) -> [Array<Product>] {
        var arrProduct = Array<Product>()

        do {
            if let html = downloadHTML(requestType: EmagKey.Search, valueRequest: searchValue) {
                document = try SwiftSoup.parse(html)

                let elements: Elements = try document.select(EmagKey.SearchMetadata.ProductClass)
                for element in elements {
                    arrProduct.append(parseProduct(element: element))
                }
            }
        } catch let error as NSError {
            log("Something went wrong on searchForProducts: \(error)")
        }

        products = [arrProduct]

        return [arrProduct]
    }

    public func setProductDetails(product: Product) {
        do {
            if let html = downloadHTML(requestType: EmagKey.ByProduct, valueRequest: product.href) {
                document = try SwiftSoup.parse(html)
                let productDetails = parseProductDetails(document: document)
                productDetails.product = product
                product.productDetails = productDetails
            }
        } catch let error as NSError {
            log("Something went wrong on setProductDetails: \(error)")
        }
    }

    private func parseProduct(element: Element) -> Product {
        let product = Product()

        do {
            if let productHref = getElement(element, EmagKey.ProductMetaData.Href) {
                let productHrefValue = try productHref.attr(EmagKey.HtmlTags.Href)
                product.href = productHrefValue
            }

            if let productName = getElement(element, EmagKey.ProductMetaData.Name) {
                let productNameValue = try productName.text()
                product.name = productNameValue
            }

            if let productPrice = getElement(element, EmagKey.ProductMetaData.Price) {
                var productPriceValue = try productPrice.text()

                if productPriceValue.lowercased().contains(EmagKey.ProductMetaData.CurrencyType.lowercased()) {
                    productPriceValue = productPriceValue.lowercased().replacingOccurrences(of: EmagKey.ProductMetaData.CurrencyType.lowercased() , with: "")
                }

                var decimalsValue = ""
                if let supDecimals = try getElement(productPrice, EmagKey.HtmlTags.Sup)?.text() {
                    productPriceValue = productPriceValue.replacingOccurrences(of: supDecimals, with: "")

                    decimalsValue = supDecimals
                }

                productPriceValue = productPriceValue.replacingOccurrences(of: " ", with: "")
                productPriceValue = productPriceValue.replacingOccurrences(of: ".", with: "")

                let productPriceDoubleValue = Double("\(productPriceValue).\(decimalsValue)")
                product.price = productPriceDoubleValue ?? 0.0
            }

            if let productSmallImageHref = getElement(element, EmagKey.ProductMetaData.SmallImageURL) {
                if let productSmallImageHrefValue = try getElement(productSmallImageHref, EmagKey.HtmlTags.Img)?.attr(EmagKey.HtmlTags.Src) {
                    product.smallImageURL = URL(string: productSmallImageHrefValue)
                }
            }
        } catch let error {
            log("Error on parseProduct: \(error)")
        }

        return product
    }

    private func parseProductDetails(document: Document) -> ProductDetails {
        let productDetails = ProductDetails()

        do {

            if let productAvailability: Element = try! document.select(EmagKey.ProductMetaData.Availability).first() {
                let productAvailabilityValue = try productAvailability.text()
                productDetails.availability = productAvailabilityValue
            }

            if let productDescription: Element = try! document.select(EmagKey.ProductMetaData.Description).first() {
                let productDescriptionValue = try productDescription.text()
                productDetails.descriptionProduct = productDescriptionValue
            }

            if let productSpecs: Element = try! document.select(EmagKey.ProductMetaData.Specs).first() {
                let productSpecsValue = try productSpecs.text()
                productDetails.specs = productSpecsValue
            }

            if let productLargelImageHref: Element = try! document.select(EmagKey.ProductMetaData.LargeImageURL).first() {
                if let productLargeImageHrefValue = try getElement(productLargelImageHref, EmagKey.HtmlTags.Img)?.attr(EmagKey.HtmlTags.Src) {
                    productDetails.largeImageURL = URL(string: productLargeImageHrefValue)
                }
            }
        } catch let error {
            log("Error on parseProductDetails: \(error)")
        }

        return productDetails
    }

    private func getElement(_ element: Element, _ elementName: String) -> Element? {
        return try! element.select(elementName).first()
    }

    private func downloadHTML(requestType: String, valueRequest: String = "") -> String? {
        var url: URL?
        if requestType != EmagKey.ByProduct {
            url = URL(string: "\(Constants.EmagURLPrefix)\(requestType)\(valueRequest.replacingOccurrences(of: " ", with: "%20"))")
        } else {
            url = URL(string: "\(valueRequest)")
        }

        if url != nil {
            // Try downloading it
            do {
                return try String(contentsOf: url!, encoding: String.Encoding.utf8)
            } catch let error {
                log("Error at downloadHTML: \(error)")
            }
        }

        return nil
    }

    // synchronizes access to self across multiple threads
    fileprivate func synchronize(_ closure: () -> Void) {
        objc_sync_enter(self)
        closure()
        objc_sync_exit(self)
    }

    // debug println with identifying prefix
    fileprivate func log(_ whatToLog: String) {
        debugPrint("========================================================================================================")
        debugPrint("EmagAPIRequest: \(whatToLog)")
        debugPrint("========================================================================================================")
    }

    // constants
    fileprivate struct Constants {
        static let ProtocolName = "https"
        static let EmagName = "emag"
        static let Domain = "ro"
        static let MobileSubDomaine = "m"
        static let EmagURLPrefix = "\(ProtocolName)://\(MobileSubDomaine).\(EmagName).\(Domain)/"
    }

    // keys in Emag responses/queries
    struct EmagKey {
        static let ByProduct = ""
        static let Search = "search/"
        static let ProductClass = ".card-item"

        struct SearchMetadata {
            static let ProductClass = ".card-item"
        }

        struct ProductMetaData {
            static let Name = ".product-title"
            static let Href = ".thumbnail-wrapper"
            static let Price = ".product-new-price"
            static let CurrencyType = "Lei"
            static let SmallImageURL = ".thumbnail"
            static let Description = ".product-page-description-text"
            static let Specs = ".gtm_product-page-specs"
            static let Availability = "span.label"
            static let LargeImageURL = ".product-gallery-image"
        }

        struct HtmlTags {
            static let Href = "href"
            static let Sup = "sup"
            static let Img = "img"
            static let Src = "src"
        }
    }
}
