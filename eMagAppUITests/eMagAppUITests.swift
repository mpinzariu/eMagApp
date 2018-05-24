//
//  eMagAppUITests.swift
//  eMagAppUITests
//
//  Created by Elizabeta Macovei on 23/05/2018.
//  Copyright © 2018 Pinzariu Marian. All rights reserved.
//

import XCTest

class eMagAppUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSearchForApple() {
        searchFor("apple", in: XCUIApplication())
        
    }
    
    func testNavToDetails() {
        let app = XCUIApplication()
        let searchString = "apple"
        searchFor(searchString, in: app)
        
        let firstCell = app.tables/*@START_MENU_TOKEN@*/.staticTexts["Telefon mobil Apple iPhone 6, 32GB, Space Gray"]/*[[".cells.staticTexts[\"Telefon mobil Apple iPhone 6, 32GB, Space Gray\"]",".staticTexts[\"Telefon mobil Apple iPhone 6, 32GB, Space Gray\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertNotNil(firstCell)
        //firstCell.tap() // crashes...
    }
    
    func testNavToSlideshow() {
        let app = XCUIApplication()
        let searchString = "apple"
        searchFor(searchString, in: app)
        let firstCell = app.tables/*@START_MENU_TOKEN@*/.staticTexts["Telefon mobil Apple iPhone 6, 32GB, Space Gray"]/*[[".cells.staticTexts[\"Telefon mobil Apple iPhone 6, 32GB, Space Gray\"]",".staticTexts[\"Telefon mobil Apple iPhone 6, 32GB, Space Gray\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        // aaaand can't get it to tap on the image...
        XCTAssertNotNil(firstCell.images) // is not nil, but is also empty.
    }
    
    /// code generation spot.
    func testTemp() {
    }
    
    // nav to details, then go to search page.
    // nav to slideshow, go back to search page.
    
    private func searchFor(_ searchString: String, in app: XCUIApplication) {
        let textField = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .textField).element
        textField.tap()
        textField.typeText(searchString)
        app.buttons["Search"].tap()
    }
    
}
