//
//  ProductDetalisViewController.swift
//  TestTableViewApp2
//
//  Created by Pinzariu Marian on 26/04/2018.
//  Copyright © 2018 Pinzariu Marian. All rights reserved.
//

import UIKit
import Foundation

class ProductDetalisViewController: UIViewController {

    @IBOutlet weak var productLargeImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productAvailabilityLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    @IBOutlet weak var separatorLineLabel: UILabel!
    @IBOutlet weak var productSpecsLabel: UILabel!
    
    private var activityIndicatorView: UIActivityIndicatorView!
    
    weak var productDetails: ProductDetails? {
        didSet {
            updateUI()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarItems()
        setupActivityIndicator()
        
        activityIndicatorView.startAnimating()
        
        updateUI()
    }

    private func setupNavigationBarItems() {
        let buttonRight =  UIButton(type: .custom)
        buttonRight.setImage(UIImage(named: "logoEmag16"), for: .normal)
        buttonRight.addTarget(self, action: #selector(rightBarButtonItemTapped), for: .touchUpInside)
        buttonRight.frame = CGRect(x: 0, y: 0, width: 50, height: 31)
        buttonRight.imageEdgeInsets = UIEdgeInsetsMake(-1, 1, 1, -41) //move image to the right
        
        let barButtonRight = UIBarButtonItem(customView: buttonRight)
        self.navigationItem.rightBarButtonItem = barButtonRight
    }
    
    private func setupActivityIndicator() {
        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.center = view.center
        view.addSubview(activityIndicatorView)
    }
    
    @objc func rightBarButtonItemTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    private func updateUI() {
        if productDetails != nil {
            
            productLargeImageView.loadImageUsingUrlString(url: productDetails!.largeImageURL!)

            if productDetails!.product != nil {
                productNameLabel.text = productDetails!.product!.name
                productPriceLabel.text = productDetails!.product!.priceString
            }
            
            productAvailabilityLabel.text = productDetails!.availability
            productDescriptionLabel.attributedText = productDetails!.descriptionProduct?.html2Attributed
            productSpecsLabel.attributedText = productDetails!.specs?.html2Attributed
            
            separatorLineLabel.isHidden = (productDetails!.specs?.isEmpty)! || (productDetails!.descriptionProduct?.isEmpty)!
            
            DispatchQueue.main.async {
                self.activityIndicatorView.stopAnimating()
            }
        } else {
            resetValues()
        }
    }
    
    private func resetValues() {
        productLargeImageView?.image = nil
        productNameLabel?.text = nil
        productPriceLabel?.text = nil
        productAvailabilityLabel.text = nil
        productDescriptionLabel.text = nil
        productSpecsLabel.text = nil
        separatorLineLabel.isHidden = true
    }
}
