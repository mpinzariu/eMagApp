//
//  ProductDetails.swift
//  TestTableViewApp
//
//  Created by Pinzariu Marian on 25/04/2018.
//  Copyright © 2018 Pinzariu Marian. All rights reserved.
//

import UIKit
import Foundation

public class ProductDetails {
    var descriptionProduct: String? = ""
    var specs: String? = ""
    var availability: String? = ""
    var largeImageURL: URL?
    var largeImageUrls: [URL]?
    
    unowned let product: Product
    
    init(product: Product, description: String, specs: String, availability: String, largeImageURL: String?, largeImageURLs: [String]?) {
        self.product = product
        self.descriptionProduct = description
        self.specs = specs
        self.availability = availability
        self.largeImageUrls = convert(largeImageURLs)
        self.largeImageURL = convert(largeImageURL)
    }
    
    private func convert(_ urlText: [String]? ) -> [URL]? {
        var result: [URL]?
        
        if urlText == nil { return nil }
        result = [URL]()
        for text in urlText! {
            if let url = convert(text) {
                result!.append(url)
            } // else, skip the string.
        }
        return result
    }
    private func convert(_ urlText: String?) -> URL? {
        var result: URL? = nil
        if let urlText = urlText {
            result = URL(string: urlText)
        }
        return result
    }
}
