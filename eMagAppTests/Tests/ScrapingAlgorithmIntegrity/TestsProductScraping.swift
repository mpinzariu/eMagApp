//
//  TestsProductScraping.swift
//  eMagAppTests
//
//  Created by Elizabeta Macovei on 17/05/2018.
//  Copyright © 2018 Pinzariu Marian. All rights reserved.
//

import Foundation
import XCTest
@testable import eMagApp

class TestsProductScraping : XCTestCase {
    // fetch a product and check the basic HTTP syntax has not changed.
    private var html: String? 
    
    override func setUp() {
        super.setUp()
        // html = fetch html from web
    }
    
    // for each
    
    override func tearDown() {
        html = nil
        super.tearDown()
    }
}
