//
//  Mocked.swift
//  eMagAppTests
//
//  Created by Elizabeta Macovei on 21/05/2018.
//  Copyright © 2018 Pinzariu Marian. All rights reserved.
//

import Foundation
@testable import eMagApp

internal class StaticHtmlRetriever: HtmlRetriever {
    func getHtml(url: URL?) -> String? {
        // look up in local cache; if not found, return nil
        return nil
    }
    
    
}

internal class FactoryNonNetwork : Factory {
    
    override var htmlRetriever: HtmlRetriever { get { return StaticHtmlRetriever() } }
}

