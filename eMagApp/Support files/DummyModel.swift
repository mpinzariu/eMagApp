//
//  Utilities.swift
//  TestTableViewApp2
//
//  Created by Pinzariu Marian on 26/04/2018.
//  Copyright © 2018 Pinzariu Marian. All rights reserved.
//

import UIKit
import Foundation

class ProductModel {
    static func generateDummyData(numberOfProducts: Int = 100) -> Array<Product> {
        var products = Array<Product>()
        //        let smallImageURL = URL(string: "https://data.promoqui.it/categories/icons/000/014/339/normal/iphone.jpg")
        let smallImageURL = URL(string: "https://s12emagst.akamaized.net/products/3514/3513955/images/res_87e8da0e749689a45ede48b2f1175217_190x190_2qb4.jpg")
        let largeImageURL = URL(string: "https://s12emagst.akamaized.net/products/3514/3513955/images/res_87e8da0e749689a45ede48b2f1175217_450x450_8k0d.jpg")
        
        for i in 0...numberOfProducts {
            let product = Product("test href\(i)",
                String.randomString(length: 300),
                Double.random().rounded(toPlaces: 2),
                smallImageURL)
            
            let productDetails = ProductDetails(description: String.randomString(length: 5000),
                                                specs: String.randomString(length: 10000),
                                                availability: String.randomString(length: 10),
                                                largeImageURL: largeImageURL)
            
            productDetails.product = product
            product.productDetails = productDetails
            products.append(product)
        }
        
        return products
    }
}
