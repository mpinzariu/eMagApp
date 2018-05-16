//
//  TestTableViewCell.swift
//  TestTableViewApp2
//
//  Created by Pinzariu Marian on 25/04/2018.
//  Copyright © 2018 Pinzariu Marian. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    // TODO: ViewController.
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    
    private var activityIndicatorView: UIActivityIndicatorView!
    
    weak var product: Product? {
        didSet {            
            updateUI()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupActivityIndicator()
        
        activityIndicatorView.startAnimating()
    }
    
    private func updateUI() {
        if product != nil {
            let onTap = UITapGestureRecognizer(target: self, action: #selector(launchSegueToImages))
            productImageView.addGestureRecognizer(onTap)
            productImageView.loadImageUsingUrlString(url: product!.smallImageURL!)

            productNameLabel?.text = product?.name
            productPriceLabel?.text = product?.priceString
            
            activityIndicatorView.stopAnimating()
        } else {
            resetValues()
        }
    }
    
    @objc
    private func launchSegueToImages() {
        //print("!!image tapped!!!")
        //performSegue(withIdentifier: "ShowImageSlider", sender: self)
    }
    
    private func setupActivityIndicator() {
        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.center = self.center
        addSubview(activityIndicatorView)
    }
    
    private func resetValues() {
        productImageView?.image = nil
        productNameLabel?.text = nil
        productPriceLabel?.text = nil
    }
}
