//
//  NetworkAccess.swift
//  eMagApp
//
//  Created by Elizabeta Macovei on 21/05/2018.
//  Copyright © 2018 Pinzariu Marian. All rights reserved.
//

import Foundation

struct NetworkAccess: HtmlRetriever {
    func getHtml(url: URL?) -> String? {
        
        var htmlValue: String? = nil
        if url != nil {
            do {
                htmlValue = try String(contentsOf: url!, encoding: String.Encoding.utf8)
            } catch let error {
                log("Error at downloadHTML: \(error)")
            }
        }
        return htmlValue
    }
    
}
