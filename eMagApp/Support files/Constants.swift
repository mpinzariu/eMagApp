//
//  Constants.swift
//  eMagApp
//
//  Created by Pinzariu Marian on 09/05/2018.
//  Copyright © 2018 Pinzariu Marian. All rights reserved.
//

import Foundation

// constants
struct URLConst {
    static let ProtocolName = "https"
    static let EmagName = "emag"
    static let Domain = "ro"
    static let MobileSubDomaine = "m"
    static let EmagURLPrefix = "\(ProtocolName)://\(MobileSubDomaine).\(EmagName).\(Domain)/"
}

struct Cache {
    public static let image = NSCache<AnyObject, AnyObject>()
    public static let html = NSCache<AnyObject, AnyObject>()
    public static let document = NSCache<AnyObject, AnyObject>()
    public static let elements = NSCache<AnyObject, AnyObject>()
}

// TODO:EM: rename to lowercase
struct EmagKey {
    static let ByProduct = ""
    static let Search = "search/"
    static let ProductClass = ".card-item"
    
    struct SearchMetadata {
        static let ProductClass = ".card-item"
    }
    
    struct ProductMetaData {
        static let Name = ".product-title"
        static let Href = ".thumbnail-wrapper"
        static let Price = ".product-new-price"
        static let CurrencyType = "Lei"
        static let SmallImageURL = ".thumbnail"
        static let Description = ".product-page-description-text"
        static let Specs = ".gtm_product-page-specs"
        static let Availability = "span.label"
        static let LargeImageURL = ".product-gallery-image"
    }
    
    struct ProductProperty {
        static let Name = "name"
        static let Href = "href"
        static let Price = "price"
        static let SmallImageURL = "smallImageURL"
    }
    // why do these exist, it's not like the HTML standard is going to change anytime soon.
    struct HtmlTags {
        static let Href = "href"
        static let Sup = "sup"
        static let Img = "img"
        static let Src = "src"
    }
}

struct ImageConst {
    static let Logo = "emagLargeImage"
    static let Icon = "iconEmag"
}
