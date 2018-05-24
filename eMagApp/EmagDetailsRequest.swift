//
//  EmagDetailsRequest.swift
//  eMagApp
//
//  Created by Elizabeta Macovei on 21/05/2018.
//  Copyright © 2018 Pinzariu Marian. All rights reserved.
//

import Foundation
import SwiftSoup

class EmagDetailsRequest : EmagRequest {
    private var product : Product
    init(product: Product, _ htmlRetriever: HtmlRetriever = Factory.htmlRetriever) {
        self.product = product
        super.init(url: URL(string: product.detailsUrl), htmlRetriever)
    }
    
    public func setProductDetails() {
        let document = getDocumentFromHtml()
        // ? if product.details != nil, do we return existing, or reload ?
        product.productDetails = parseProductDetails(document: document)
    }
    
    private func parseProductDetails(document: Document) -> ProductDetails {
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
            
            productDetails = ProductDetails(product: product, description: description, specs: specs, availability: availability, largeImageURL: productLargeImageHrefValue,  largeImageURLs: imageUrls)
        } catch let error {
            log("Error on parseProductDetails: \(error)")
        }
        
        return productDetails!
    }
}
