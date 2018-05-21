//
//  EmagDetailsRequest.swift
//  eMagApp
//
//  Created by Elizabeta Macovei on 21/05/2018.
//  Copyright © 2018 Pinzariu Marian. All rights reserved.
//

import Foundation
import SwiftSoup

class EmagDetailsRequest : EmagRequest {
    private var product : Product
    init(product: Product) {
        self.product = product
        super.init(url: URL(string: product.detailsUrl))
    }
    
    public func setProductDetails() {
        let document = getDocumentFromHtml(
            urlString: product.detailsUrl)
        // ? if product.details != nil, do we return existing, or reload ?
        let productDetails = HelperParse.parseProductDetails(document: document)
        productDetails.product = product
        product.productDetails = productDetails
    }
}
