//
//  Helper.swift
//  eMagAppTests
//
//  Created by Elizabeta Macovei on 22/05/2018.
//  Copyright © 2018 Pinzariu Marian. All rights reserved.
//

import Foundation
@testable import eMagApp

// TODO: ? convert to EmagProductRequest extension?
struct ProductHelper {
    
    static func getAllProductsToClosure(_ sut: EmagProductsRequest, _ appendingClosure: @escaping (Product) -> Void) {
        
        sut.fetchProducts() { prod in
            appendingClosure(prod)
        }
    }
    
    static func getAllProducts(_ sut: EmagProductsRequest) -> [Product] {
        
        var arrProducts = [Product]()
        
        ProductHelper.getAllProductsToClosure(sut) { prod in
            arrProducts.append(prod)
        }
        return arrProducts
    }
}
