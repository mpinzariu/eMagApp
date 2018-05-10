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
    
    weak var product: Product? = nil
    
    init(description: String, specs: String, availability: String, largeImageURL: URL?) {
        self.descriptionProduct = description
        self.specs = specs
        self.availability = availability
        self.largeImageURL = largeImageURL
    }
}
