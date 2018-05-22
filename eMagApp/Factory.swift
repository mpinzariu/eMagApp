//
//  Factoy.swift
//  eMagApp
//
//  Created by Elizabeta Macovei on 21/05/2018.
//  Copyright © 2018 Pinzariu Marian. All rights reserved.
//


internal class Factory {
    
    var htmlRetriever: HtmlRetriever { get { return NetworkAccess() } }
}
