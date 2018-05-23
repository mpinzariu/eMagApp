//
//  ProductTesting.swift
//  eMagAppTests
//
//  Created by Elizabeta Macovei on 17/05/2018.
//  Copyright © 2018 Pinzariu Marian. All rights reserved.
//

import XCTest
@testable import eMagApp

/**
 Test suite checking that Products are built correctly from the scraped HTML.
 Bypasses internet acess, and uses cache - use MockedFactory for retrieving HTML.
 */
class ProductScraperTesting: XCTestCase {
    
    // MARK: - test suite internals
    private var sut: EmagProductsRequest!
    
    override func setUp() {
        super.setUp()
        sut = EmagProductsRequest(search: TestConstants.searchStringApple, MockedFactory().htmlRetriever)
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    //MARK: - Tests
    
    /// just check that the SUT instantiation has executed.
    func testHasData() {
        XCTAssertNotNil(sut)
    }
    
    /// count the number of products that has been retrieved - sample text has 36 products.
    func testHasProducts() {
        let arrProducts = ProductHelper.getAllProducts(sut)
        XCTAssertEqual(arrProducts.count, 36)
    }
    
    /// check that a product is retrieved in full, but not ProductDetails.
    func testProductHasAllFields() {
        var prod: Product? = nil
        ProductHelper.getAllProductsToClosure(sut) { product in
            if product.detailsUrl == TestConstants.prodUrlFirst {
                prod = product
            }
        }
        
        XCTAssertNotNil(prod)
        XCTAssertNotNil(prod?.detailsUrl)
        XCTAssertNotNil(prod?.price)
        XCTAssertNotNil(prod?.priceString)
        XCTAssertNotNil(prod?.name)
        XCTAssertNotNil(prod?.smallImageURL)
        
        XCTAssertNil(prod?.productDetails)
    }
    
    
}
