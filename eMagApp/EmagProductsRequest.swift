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
    
    init(search: String) {
        self.searchString = search
        
        var url = URL(string: URLConst.EmagURLPrefix)
        url?.appendPathComponent("search")
        url?.appendPathComponent(search)
        print("Product URL = '\(url!)'")
        super.init(url: url)
    }
    // MARK: - Functions
    
    public func searchForProducts(handler: (PropertyList?) -> Void) {
        do {
            let document = getDocumentFromHtml(urlString: searchString!)
            
            elementsFromSearch = try document.select(EmagKey.SearchMetadata.ProductClass)
            if elementsFromSearch != nil && elementsFromSearch!.array().count > 0 {
                for element in elementsFromSearch! {
                    handler(HelperParse.parseProduct(element: element))
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
}
