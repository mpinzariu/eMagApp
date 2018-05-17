//
//  ProductCellDelegate.swift
//  eMagApp
//
//  Created by Elizabeta Macovei on 16/05/2018.
//  Copyright © 2018 Pinzariu Marian. All rights reserved.
//

import UIKit
import Foundation

class ProductCellDelegate : ProductCellProtocol  {
    
    private var model: Product?
    private var onTapAction: ( (_ : Product) -> Void)?
    
    func updateUI(_ cell: ProductTableViewCell, _ product: Product?
        , _ onTap:  @escaping  (Product) -> Void) {
        model = product
        onTapAction = onTap
        if product != nil {
            let onTap = UITapGestureRecognizer(target: self, action: #selector(execTap))
            cell.productImageView.addGestureRecognizer(onTap)
            cell.productImageView.loadImageUsingUrlString(url: product!.smallImageURL!)
            cell.productNameLabel?.text = product?.name
            cell.productPriceLabel?.text = product?.priceString
            
        } else {
            resetValues(cell: cell)
        }
        cell.stopAnimating()
    }
    
    @objc private func execTap() {
        if onTapAction != nil {
            onTapAction!(model!)
        }
    }
    
    private func resetValues(cell: ProductTableViewCell) {
        cell.productImageView?.image = nil
        cell.productNameLabel?.text = nil
        cell.productPriceLabel?.text = nil
    }
}
