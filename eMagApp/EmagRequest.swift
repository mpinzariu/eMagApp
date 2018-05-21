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
    fileprivate var url: URL?
    private var htmlRetriever: HtmlRetriever
    
    init(url: URL?) {
        self.url = url
        self.htmlRetriever = Factory().htmlRetriever
        
    }
    
    // MARK: - Helper Functions

    func getDocumentFromHtml(urlString: String) -> Document {
        if let documentFromCache = Cache.document.object(forKey: urlString as AnyObject) as? Document {
            return documentFromCache
        }
        
        var document: Document? = nil
        do {
            let htmlValue = htmlRetriever.getHtml(url: url)
            document = try SwiftSoup.parse(htmlValue!)
            Cache.document.setObject(document as AnyObject, forKey: urlString as AnyObject)
        } catch let error as NSError {
            log("Something went wrong on getDocumentFromHtml: \(error)")
        }
        
        return document!
    }
}

extension EmagRequest : Equatable {
    public static func == (lhs: EmagRequest, rhs: EmagRequest) -> Bool {
        return lhs.url == rhs.url
    }
}

