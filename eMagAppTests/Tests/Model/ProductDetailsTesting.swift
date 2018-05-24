//
//  ProductDetailsTesting.swift
//  eMagAppTests
//
//  Created by Elizabeta Macovei on 22/05/2018.
//  Copyright © 2018 Pinzariu Marian. All rights reserved.
//

// no longer viable: EmagDetails uses Product from init, and reads details from HtmlProvider... rethink!


import XCTest
@testable import eMagApp

/**
 Test suite checking Details. Doesn't use eMagScraper.
 */
class ProductDetailsTesting: XCTestCase {

    func testImageUrls_base() {
        let prod = makeProduct(TestConstants.prodUrlFirst)
        let sut = EmagDetailsRequest(product: prod, MockedFactory.htmlRetriever)
        
        sut.setProductDetails()
        
        if let details = prod.productDetails {
            XCTAssertNotNil(details.largeImageURL)
            XCTAssertNotNil(details.largeImageUrls)
            
        } else {
            XCTFail("Produc Details have not been set!")
        }
    }

    func testDetailsWithNoImageUrls() {
        let prod = makeProduct(TestConstants.prodUrlSecond)
        let sut = EmagDetailsRequest(product: prod, MockedFactory.htmlRetriever)
        
        sut.setProductDetails()
        
        if let details = prod.productDetails {
            XCTAssertNil(details.largeImageURL)
            XCTAssertNotNil(details.largeImageUrls)
            XCTAssertEqual(0, details.largeImageUrls?.count)
        } else {
            XCTFail("Product Details have not been set!")
        }
    }
    
    /// make a Product for use in details.
    private func makeProduct(_ detailsUrl: String) -> Product {
        return Product(detailsUrl, "test product for Details", 13.33, URL(string: "/img"))
    }
    
    
}
