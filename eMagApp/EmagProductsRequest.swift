//
//  EmagProductsRequest.swift
//  eMagApp
//
//  Created by Elizabeta Macovei on 21/05/2018.
//  Copyright © 2018 Pinzariu Marian. All rights reserved.
//

import Foundation
import SwiftSoup

class EmagProductsRequest : EmagRequest {
    
    private var searchString: String?
    private var elementsFromSearch: Elements? = nil
    
    init(search: String, _ htmlRetriever: HtmlRetriever = Factory().htmlRetriever) {
        self.searchString = search
        
        var url = URL(string: URLConst.EmagURLPrefix)
        url?.appendPathComponent("search")
        url?.appendPathComponent(search)
        super.init(url: url, htmlRetriever)
    }
    
    // MARK: - Functions
    
    public func searchForProducts(handler: (PropertyList?) -> Void) {
        do {
            let document = getDocumentFromHtml(urlString: searchString!)
            
            elementsFromSearch = try document.select(EmagKey.SearchMetadata.ProductClass)
            if elementsFromSearch != nil && elementsFromSearch!.array().count > 0 {
                for element in elementsFromSearch! {
                    handler(parseProduct(element: element))
                }
            }
        } catch let error as NSError {
            log("Something went wrong on downloadHTML: \(error)")
        }
    }
    
    public func fetchProducts(_ handler: @escaping (Product) -> Void) {
        
        searchForProducts { results in
            if let dictionary = results as? Dictionary<String, AnyObject>,
                let newProduct = Product(data: dictionary)
            {
                handler(newProduct)
            }
        }
    }
    
    private func parseProduct(element: Element) -> PropertyList? {
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
    
}
