//
//  DetailsScraperTesting.swift
//  eMagAppTests
//
//  Created by Elizabeta Macovei on 22/05/2018.
//  Copyright © 2018 Pinzariu Marian. All rights reserved.
//

import XCTest
@testable import eMagApp

/**
 Test suite checking that Product Details are built correctly from the scraped HTML.
 Bypasses internet acess, and uses cache - use MockedFactory for retrieving HTML.
 */
class DetailsScraperTesting: XCTestCase {
    
    private var product: Product!
    private var sut: EmagDetailsRequest!
    
    override func setUp() {
        super.setUp()
        let parentSut = EmagProductsRequest(search: TestConstants.searchStringApple, MockedFactory().htmlRetriever)
        ProductHelper.getAllProductsToClosure(parentSut) { p in
            if p.detailsUrl == TestConstants.prodUrlFirst {
                self.product = p
            }
        }
        XCTAssertNotNil(product, "Stopping Details Unit Testing: could not retrieve parent Product.")
        sut = EmagDetailsRequest(product: product, MockedFactory().htmlRetriever)
    }
    
    override func tearDown() {
        sut = nil
        product = nil
        super.tearDown()
    }
    
    /// SUT instantiation has executed, product is created and details are not (yet) retrieved.
    func testHasData() {
        XCTAssertNotNil(sut)
        XCTAssertNotNil(product)
        XCTAssertNil(product.productDetails)
    }
    
    /// details for specified product are retrieved
    func testCreatingDetails() {
        sut.setProductDetails()
        XCTAssertNotNil(product.productDetails)
    }
    
}
