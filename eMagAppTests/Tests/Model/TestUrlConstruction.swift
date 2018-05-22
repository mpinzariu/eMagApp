//
//  TestUrlConstruction.swift
//  eMagAppTests
//
//  Created by Elizabeta Macovei on 18/05/2018.
//  Copyright © 2018 Pinzariu Marian. All rights reserved.
//

import XCTest
@testable import eMagApp

/**
 Test suite checking that EmagProductsRequest properly handles URL construction, from user-defined search string to scraper-built URL.
 */
class TestUrlConstruction : XCTestCase {
    //MARK: - Tests
    
    /// search string results in expected URL.
    func testUrlSingleWord() {
        let expectedUrl = "https://m.emag.ro/search/nokia"
        let sut = EmagProductsRequest(search: "nokia", MockedFactory().htmlRetriever)
        XCTAssertNotNil(sut.url)
        let actualUrl = sut.url!.absoluteString
        
        XCTAssertEqual(expectedUrl.caseInsensitiveCompare(actualUrl), ComparisonResult.orderedSame)
    }
    
    // 2-word search string results in word%20word
    func testUrlTwoWords() {
        let expectedUrl = "https://m.emag.ro/search/laptop%20asus"
        let sut = EmagProductsRequest(search: "laptop asus", MockedFactory().htmlRetriever)
        XCTAssertNotNil(sut.url)
        let actualUrl = sut.url!.absoluteString
        
        XCTAssertEqual(expectedUrl.caseInsensitiveCompare(actualUrl), ComparisonResult.orderedSame)
    }
    
    // what other encodings do I check?
    
    
}
