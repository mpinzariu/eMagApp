//
//  TestsProductScraping.swift
//  eMagAppTests
//
//  Created by Elizabeta Macovei on 17/05/2018.
//  Copyright © 2018 Pinzariu Marian. All rights reserved.
//

import Foundation
import SwiftSoup
import XCTest
@testable import eMagApp

/**
 Test suite checking that the scraped HTML for Products has not changed in a way that breaks our EMag Parser.
 This test suite uses internet access, and doesn't use the cache.
 */
class TestsEmagProductScraping : XCTestCase {
    
    private var doc: Document!
    
    override func setUp() {
        super.setUp()
        if doc == nil {
        let sut = EmagProductsRequest(search: "apple")
        let html = Factory.htmlRetriever.getHtml(url: sut.url)
        do {
            doc = try SwiftSoup.parse(html!)
        } catch { XCTFail("") }
        }
    }
    
    override func tearDown() {
        doc = nil
        super.tearDown()
    }
    
    func testProductItems() {
        do {
            let prodNodes = try getAllProducts()
            XCTAssertNotNil(prodNodes)
            XCTAssertGreaterThan(prodNodes.array().count, 0)
        } catch {
            XCTFail()
        }
    }
    
    func testProductDetailsUrl() {
        do {
            if let prodNode = (try getAllProducts()).first(),
                let productHref = try prodNode.select(EmagKey.ProductMetaData.Href).first()
            {
                let actual = try productHref.attr(EmagKey.HtmlTags.Href)
                XCTAssertNotNil(actual)
                XCTAssertFalse(actual.isEmpty)
            }
        } catch {
            XCTFail()
        }
    }
    
    private func getAllProducts() throws -> Elements {
        return try doc.select(EmagKey.SearchMetadata.ProductClass)
    }
}
