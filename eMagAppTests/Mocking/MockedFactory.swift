//
//  Mocked.swift
//  eMagAppTests
//
//  Created by Elizabeta Macovei on 21/05/2018.
//  Copyright © 2018 Pinzariu Marian. All rights reserved.
//

import Foundation
@testable import eMagApp

internal class MockedFactory : Factory {
    
    override var htmlRetriever: HtmlRetriever { get { return StaticHtmlRetriever() } }
}

internal class StaticHtmlRetriever: HtmlRetriever {
    
    private static var cache = [String:String]()
    init() {
        if StaticHtmlRetriever.cache.count == 0 {
            populateCache()
        }
    }
    
    func getHtml(url: URL?) -> String? {
        if let key = url?.absoluteString,
            let rawHtml = StaticHtmlRetriever.cache[key]
        {
            return rawHtml
        }
        
        return nil
    }
    
    internal func populateCache() {
        // search results for keyword 'apple'
        insertToCache(key: TestConstants.searchUrlApple, fileName: "apple")
        // details for the first 3 results in the above search:
        insertToCache(key: TestConstants.prodUrlFirst, fileName: "0")
        insertToCache(key: TestConstants.prodUrlSecond, fileName: "1")
        insertToCache(key: TestConstants.prodUrlThird, fileName: "2")
        // images?
    }
    
    private func insertToCache(key: String, fileName: String) {
        if let rawHtml = readFromText(fileName: fileName) {
            StaticHtmlRetriever.cache[key] = rawHtml
        } else {
            assertionFailure("Could not retrieve stored Product data; testing cannot continue.")
        }
    }
    
    private func readFromText(fileName: String) -> String? {
        let bundle: Bundle = Bundle(for: type(of: self ))
        if let path = bundle.path(forResource: fileName, ofType: "htm")
        {
            var fileContent: String? = nil
            do {
                fileContent = try String(contentsOfFile: path)
            } catch {
                //
                print("couldn't read file '\(fileName)' as string.")
            }
            return fileContent
        } else {
            print ("Couldn't open file '\(fileName)', presumed to be .htm")
        }
        return nil
    }
    
}

