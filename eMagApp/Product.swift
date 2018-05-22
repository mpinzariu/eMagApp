//
//  Product.swift
//  TestTableViewApp
//
//  Created by Pinzariu Marian on 25/04/2018.
//  Copyright © 2018 Pinzariu Marian. All rights reserved.
//

import Foundation

public class Product { 
    var detailsUrl: String
    var name: String
    var price: Double
    var priceString: String {
        return "\(self.price.format(".2")) Lei"
    }
    var smallImageURL: URL?
    var productDetails: ProductDetails?
    
    init(_ href: String, _ name: String, _ price: Double, _ smallImageURL: URL?) {
        self.detailsUrl = href
        self.name = name
        self.price = price
        self.smallImageURL = smallImageURL
    }
    
    convenience init?(data: Dictionary<String, AnyObject>?) {
        guard
            let href = data?[EmagKey.ProductProperty.Href] as? String,
            let name = data?[EmagKey.ProductProperty.Name] as? String,
            let price = data?[EmagKey.ProductProperty.Price] as? Double,
            let smallImageURL = data?[EmagKey.ProductProperty.SmallImageURL] as? URL
            else {
                return nil
        }
        
        self.init(href, name, price, smallImageURL)
    }
}

extension Product : Equatable {
    
    public static func == (left: Product, right: Product) -> Bool {
        return left.detailsUrl.caseInsensitiveCompare(right.detailsUrl) == ComparisonResult.orderedSame && (left.name == right.name)
    }
    
}
