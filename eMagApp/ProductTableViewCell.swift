//
//  TestTableViewCell.swift
//  TestTableViewApp2
//
//  Created by Pinzariu Marian on 25/04/2018.
//  Copyright © 2018 Pinzariu Marian. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    //MARK: - Properties
    var delegate: ProductCellProtocol?
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    
    private var activityIndicatorView: UIActivityIndicatorView!
    
    // MARK: - View Behavior
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupActivityIndicator()
        activityIndicatorView.startAnimating()
    }
    
    func stopAnimating() {
        activityIndicatorView.stopAnimating()
    }
    
    private func setupActivityIndicator() {
        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.center = self.center
        addSubview(activityIndicatorView)
    }
    
}
