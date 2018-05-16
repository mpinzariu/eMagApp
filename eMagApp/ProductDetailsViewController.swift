//
//  ProductDetalisViewController.swift
//  TestTableViewApp2
//
//  Created by Pinzariu Marian on 26/04/2018.
//  Copyright © 2018 Pinzariu Marian. All rights reserved.
//

import UIKit
import Foundation

class ProductDetailsViewController: UIViewController {

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
            DispatchQueue.main.async { [weak self] in
                self?.updateUI()
            }
        }
    }
    private let idSegueToImages = "ShowImageSlider"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = makeEmagNavigationButton(touchAction: #selector(rightBarButtonItemTapped), customEdgeInset: UIEdgeInsetsMake(-1, 1, 1, -41))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        
        activityIndicatorView = makeActivityIndicator()
        activityIndicatorView.center = view.center
        view.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
        
        updateUI()
    }
    
    @objc func rightBarButtonItemTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    private func updateUI() {
        if productDetails != nil {
            let onTap = UITapGestureRecognizer(target: self, action: #selector(launchSegueToImages))
            productLargeImageView.loadImageUsingUrlString(url: productDetails!.largeImageURL!)
            productLargeImageView.addGestureRecognizer(onTap)
            
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
    
    @objc
    private func launchSegueToImages() {
        performSegue(withIdentifier: idSegueToImages, sender: self)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == idSegueToImages,
            let imagesVC = segue.destination as? ImageSliderViewController,
            let imageUrls = productDetails?.largeImageUrls
        {
                imagesVC.imageUrls = imageUrls
                print(" >> from Details to images with \(imageUrls.count ) image URLs.")
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
