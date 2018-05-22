//
//  EmagAPIRequest.swift
//  eMagApp
//
//  Created by Pinzariu Marian on 07/05/2018.
//  Copyright © 2018 Pinzariu Marian. All rights reserved.
//
import Foundation
import SwiftSoup


class EmagRequest {
    private(set) var url: URL?
    private var htmlRetriever: HtmlRetriever
    
    init(url: URL?, _ htmlRetriever: HtmlRetriever) {
        self.url = url
        self.htmlRetriever = htmlRetriever
    }
    
    // MARK: - Helper Functions
    // TODO: remove UrlSring parameter; we already have it.
    func getDocumentFromHtml(urlString: String) -> Document {
        if let documentFromCache = Cache.document.object(forKey: urlString as AnyObject) as? Document {
            return documentFromCache
        }
        
        var document: Document? = nil
        do {
            if let htmlValue = htmlRetriever.getHtml(url: url) {
                document = try SwiftSoup.parse(htmlValue)
                Cache.document.setObject(document as AnyObject, forKey: urlString as AnyObject)
            } else {
                print("No HTML could be retrieved for '\(urlString)'")
            }
        } catch let error as NSError {
            log("Something went wrong on getDocumentFromHtml: \(error)")
        }
        
        return document!
    }
    
    internal func getElement(_ element: Element, _ elementName: String) -> Element? {
        return try! element.select(elementName).first()
    }
}

extension EmagRequest : Equatable {
    public static func == (lhs: EmagRequest, rhs: EmagRequest) -> Bool {
        return lhs.url == rhs.url
    }
}

