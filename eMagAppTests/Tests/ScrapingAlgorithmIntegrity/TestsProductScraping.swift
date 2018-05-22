//
//  TestsProductScraping.swift
//  eMagAppTests
//
//  Created by Elizabeta Macovei on 17/05/2018.
//  Copyright © 2018 Pinzariu Marian. All rights reserved.
//

import Foundation
// import SwiftSoup TODO: install SwiftSoup for tests.
import XCTest
@testable import eMagApp

/**
 Test suite checking that the scraped HTML for Products has not changed in a way that breaks our EMag Parser.
 This test suite uses internet access, and doesn't use the cache.
 
 */
class TestsEmagProductScraping : XCTestCase {
    
    //private static var html: String? // also add a timestamp?
    //private var doc: Document?
    
    override func setUp() {
        super.setUp()
        //let html = Factory().htmlRetriever.getHtml(url: URL(String: ""))
        //doc =
    }
    
    // for each
    
    override func tearDown() {
        //html = nil
        //doc = nil
        super.tearDown()
    }
}
