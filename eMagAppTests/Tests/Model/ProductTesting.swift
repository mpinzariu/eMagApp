//
//  ProductTesting.swift
//  eMagAppTests
//
//  Created by Elizabeta Macovei on 22/05/2018.
//  Copyright © 2018 Pinzariu Marian. All rights reserved.
//

import XCTest
@testable import eMagApp

/**
 Test suite checking Product internal integrity. No access to EmagRequest.
 */
class ProductTesting : XCTestCase {
    
    // MARK: - price formatting
    func testPriceFormatting_base() {
        let expected = "199.49 Lei"
        let prod = Product("", "Testing price formatting", 199.49, nil)
        
        XCTAssertEqual(expected, prod.priceString)
    }
    
    func testPriceFormatting_impreciseValue() {
        let expected = "199.49 Lei"
        let prod = Product("", "Testing price formatting", 199.4899999, nil)
        
        XCTAssertEqual(expected, prod.priceString)
    }
    
    func testPriceFormatting_noCents() {
        let expected = "199.00 Lei"
        let prod = Product("", "Testing price formatting", 199, nil)
        
        XCTAssertEqual(expected, prod.priceString)
    }
    
    //MARK: - convenience init from Dictionary
    
    func testNoProductOnNilDetailsUrl() {
        let data = makeDictionary(nil, "Testing nil input for detailsURL", 11.4, URL(string: "https://host.com"))
        let actualProd = Product(data: data)
        
        XCTAssertNil(actualProd)
    }
    
    func testNoProductOnNilTitle() {
        let data = makeDictionary("", nil, 11.4, URL(string: "https://host.com"))
        let actualProd = Product(data: data)
        
        XCTAssertNil(actualProd)
    }
    
    func testNoProductOnNilPrice() {
        let data = makeDictionary("", "Testing nil input for price", nil, URL(string: "https://host.com"))
        let actualProd = Product(data: data)
        
        XCTAssertNil(actualProd)
    }
    
    func testNoProductOnNilThumbnailUrl() {
        let data = makeDictionary("", "Testing nil input for price", 23.2, nil)
        let actualProd = Product(data: data)
        
        XCTAssertNil(actualProd)
    }
    
    // equality for Product.
    func testEquality_base() {
        let lhs = Product("http://details.url", "Title", 11.11, URL(string: "https://host.com/data"))
        let rhs = Product("http://details.url", "Title", 22, URL(string: "https://host.com/detail"))
        
        XCTAssertEqual(lhs, rhs)
    }
    
    func testEquality_ignoreURLCase() {
        let lhs = Product("http://details.url", "Title", 11.11, URL(string: "https://host.com/data"))
        let rhs = Product("http://DETAILS.url", "Title", 22, URL(string: "https://host.com/detail"))
        
        XCTAssertEqual(lhs, rhs)
    }
    
    func testEquality_dontIgnoreTitleCase() {
        let lhs = Product("http://details.url", "Title", 11.11, URL(string: "https://host.com/data"))
        let rhs = Product("http://details.url", "title", 22, URL(string: "https://host.com/detail"))
        
        XCTAssertNotEqual(lhs, rhs)
    }
    
    //MARK: - helper method.
    private func makeDictionary(_ detailsUrl: String?, _ name: String?, _ price: Double?, _ thumbnailUrl: URL?) -> [String:AnyObject] {
        var dict = [String:AnyObject]()
        
        dict[EmagKey.ProductProperty.Href] = detailsUrl as AnyObject
        dict[EmagKey.ProductProperty.Name] = name as AnyObject
        dict[EmagKey.ProductProperty.Price] = price as AnyObject
        dict[EmagKey.ProductProperty.SmallImageURL] = thumbnailUrl as AnyObject
        
        return dict
    }
}
