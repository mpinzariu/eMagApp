//
//  ProductCellProtocol.swift
//  eMagApp
//
//  Created by Elizabeta Macovei on 16/05/2018.
//  Copyright © 2018 Pinzariu Marian. All rights reserved.
//

import Foundation

protocol ProductCellProtocol {
    func updateUI(_ cell: ProductTableViewCell, _ product: Product?, _ onTap: @escaping (_: Product) -> Void )
}
