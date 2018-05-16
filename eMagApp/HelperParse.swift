//
//  EmagParse.swift
//  eMagApp
//
//  Created by Pinzariu Marian on 09/05/2018.
//  Copyright © 2018 Pinzariu Marian. All rights reserved.
//

import Foundation
import SwiftSoup

struct HelperParse {
    public static func parseProduct(element: Element) -> PropertyList? {
        var propertyList: Dictionary = Dictionary<String, AnyObject>()
        
        do {
            if let productHref = getElement(element, EmagKey.ProductMetaData.Href) {
                let productHrefValue = try productHref.attr(EmagKey.HtmlTags.Href)
                propertyList[EmagKey.ProductProperty.Href] = productHrefValue as AnyObject
            }
            
            if let productName = getElement(element, EmagKey.ProductMetaData.Name) {
                let productNameValue = try productName.text()
                propertyList[EmagKey.ProductProperty.Name] = productNameValue as AnyObject
            }
            
            if let productPrice = getElement(element, EmagKey.ProductMetaData.Price) {
                var productPriceValue = try productPrice.text()
                
                if productPriceValue.lowercased().contains(EmagKey.ProductMetaData.CurrencyType.lowercased()) {
                    productPriceValue = productPriceValue.lowercased().replacingOccurrences(of: EmagKey.ProductMetaData.CurrencyType.lowercased() , with: "")
                }
                
                var decimalsValue = ""
                if let supDecimals = try getElement(productPrice, EmagKey.HtmlTags.Sup)?.text() {
                    productPriceValue = String(productPriceValue.dropLast(supDecimals.count + 1))
                    
                    decimalsValue = supDecimals
                }
                
                productPriceValue = productPriceValue.replacingOccurrences(of: " ", with: "")
                productPriceValue = productPriceValue.replacingOccurrences(of: ".", with: "")
                
                let productPriceDoubleValue = Double("\(productPriceValue).\(decimalsValue)")
                propertyList[EmagKey.ProductProperty.Price] = productPriceDoubleValue as AnyObject
            }
            
            if let productSmallImageHref = getElement(element, EmagKey.ProductMetaData.SmallImageURL) {
                if let productSmallImageHrefValue = try getElement(productSmallImageHref, EmagKey.HtmlTags.Img)?.attr(EmagKey.HtmlTags.Src) {
                    propertyList[EmagKey.ProductProperty.SmallImageURL] = (URL(string: productSmallImageHrefValue)) as AnyObject
                }
            }
        } catch let error {
            log("Error on parseProduct: \(error)")
        }
        
        return propertyList as PropertyList
    }
    
    public static func parseProductDetails(document: Document) -> ProductDetails {
        var productDetails: ProductDetails? = nil
        
        do {
            var availability = ""
            var description = ""
            var specs = ""
            var productLargeImageHrefValue: String? = nil
            var imageUrls: [String]? = [String]()
            
            if let productAvailability: Element = try! document.select(EmagKey.ProductMetaData.Availability).first() {
                availability = try productAvailability.text()
            }
            
            if let productDescription: Element = try! document.select(EmagKey.ProductMetaData.Description).first() {
                description = try productDescription.html()
            }
            
            if let productSpecs: Element = try! document.select(EmagKey.ProductMetaData.Specs).first() {
                specs = try productSpecs.html()
            }
            
            if let productLargelImageHref: Element = try! document.select(EmagKey.ProductMetaData.LargeImageURL).first() {
                productLargeImageHrefValue = (try getElement(productLargelImageHref, EmagKey.HtmlTags.Img)?.attr(EmagKey.HtmlTags.Src)) ?? nil
            }
            
            let root = try! document.select("div#product-gallery").first()
            let imageNodes: Elements = try! root!.select("a")
            for node in imageNodes {
                let url = try node.attr("href")
                if !url.isEmpty && !(imageUrls!.contains(url)) {
                    imageUrls!.append(url)
                }
            }
            
            productDetails = ProductDetails(description: description, specs: specs, availability: availability, largeImageURL: productLargeImageHrefValue,  largeImageURLs: imageUrls)
        } catch let error {
            log("Error on parseProductDetails: \(error)")
        }
        
        return productDetails!
    }
    
    private static func getElement(_ element: Element, _ elementName: String) -> Element? {
        return try! element.select(elementName).first()
    }
}
