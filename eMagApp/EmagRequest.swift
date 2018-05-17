//
//  EmagAPIRequest.swift
//  eMagApp
//
//  Created by Pinzariu Marian on 07/05/2018.
//  Copyright © 2018 Pinzariu Marian. All rights reserved.
//
import Foundation
import SwiftSoup

public class EmagRequest {
    
    private var requestValue: String?
    private var elementsFromSearch: Elements? = nil
    private var htmlValue: String? = ""
    
    public init(search: String) {
        self.requestValue = search
    }
    
    // MARK: - Functions
    public func downloadHTML() {
        do {
            htmlValue = getDownloadHtml(requestType: EmagKey.Search, href: requestValue!)
            let document = getDocumentFromHtml(requestType: EmagKey.Search, href: requestValue!)
            
            elementsFromSearch = try document.select(EmagKey.SearchMetadata.ProductClass)
        } catch let error as NSError {
            log("Something went wrong on downloadHTML: \(error)")
        }
    }
    
    public func searchForProducts(handler: (PropertyList?) -> Void) {
        if elementsFromSearch != nil && elementsFromSearch!.array().count > 0 {
            for element in elementsFromSearch! {
                handler(HelperParse.parseProduct(element: element))
            }
        }
    }
    
    public func fetchProducts(_ handler: @escaping (Product) -> Void) {
        
        searchForProducts { results in
            if let dictionary = results as? Dictionary<String, AnyObject>,
               let newProduct = Product(data: dictionary) {
                
                handler(newProduct)
            }
        }
    }
    
    public func setProductDetails(product: Product) {
        htmlValue = getDownloadHtml(requestType: EmagKey.ByProduct, href: product.href)
        let document = getDocumentFromHtml(requestType: EmagKey.ByProduct, href: product.href)
        
        let productDetails = HelperParse.parseProductDetails(document: document)
        productDetails.product = product
        product.productDetails = productDetails
    }
    
    // MARK: - Helper Functions
    private func getDocumentFromHtml(requestType: String, href: String) -> Document {
        var document: Document = Document.init("")
        
        do {
            if let documentFromCache = Cache.document.object(forKey: href as AnyObject) as? Document {
                document = documentFromCache
            } else {
                if htmlValue == nil {
                    htmlValue = getDownloadHtml(requestType: requestType, href: href)
                }
                
                document = try SwiftSoup.parse(htmlValue!)
                Cache.document.setObject(document as AnyObject, forKey: href as AnyObject)
            }
        } catch let error as NSError {
            log("Something went wrong on getDocumentFromHtml: \(error)")
        }
        
        return document
    }
    
    private func getDownloadHtml(requestType: String, href: String) -> String {
        var htmlValue = ""
        
        if let htmlFromCache = Cache.html.object(forKey: href as AnyObject) as? String {
            htmlValue = htmlFromCache
        } else if let html = downloadHTML(requestType: requestType, valueRequest: href) {
            htmlValue = html
        }
        
        return htmlValue
    }
    
    private func downloadHTML(requestType: String, valueRequest: String = "") -> String? {
        var url: URL?
        if requestType != EmagKey.ByProduct {
            url = URL(string: "\(URLConst.EmagURLPrefix)\(requestType)\(valueRequest.replacingOccurrences(of: " ", with: "%20"))")
        } else {
            url = URL(string: "\(valueRequest)")
        }
        
        if url != nil {
            do {
                return try String(contentsOf: url!, encoding: String.Encoding.utf8)
            } catch let error {
                log("Error at downloadHTML: \(error)")
            }
        }
        
        return nil
    }
}

extension EmagRequest : Equatable {
    public static func == (lhs: EmagRequest, rhs: EmagRequest) -> Bool {
        return lhs.requestValue == rhs.requestValue
    }
}
