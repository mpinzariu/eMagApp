//
//  TestTableViewController.swift
//  TestTableViewApp2
//
//  Created by Pinzariu Marian on 25/04/2018.
//  Copyright © 2018 Pinzariu Marian. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    private let cellIdentifier = "cell"
    private let productIdentifier = "Product"
    private let idSegueToDetails = "ShowProductDetails"
    private let idSegueToImages = "ShowImageSlider"
    
    private var lastEmagAPIRequest: EmagRequest?
    private var activityIndicatorView: UIActivityIndicatorView!
    private var products: [Product] = []
    
    var searchText: String? {
        didSet {            
            products.removeAll()
            title = searchText
        }
    }

    private func emagRequest() -> EmagRequest? {
        if lastEmagAPIRequest != nil {
            return lastEmagAPIRequest
        }
        
        if let searchText = searchText, !searchText.isEmpty {
            return EmagRequest(search: searchText)
        }
        
        return nil
    }
    
    private func searchForProducts() {
        if let request = emagRequest() {
            lastEmagAPIRequest = request

            tableView.separatorStyle = .none
            activityIndicatorView.startAnimating()
            
            DispatchQueue.global(qos: .userInteractive).async {
                [weak self] in self?.asyncLoad(request)
            }
        }
    }
    
    private func asyncLoad(_ request: EmagRequest) {
        self.lastEmagAPIRequest!.downloadHTML()
        request.fetchProducts { [unowned self] newProduct in
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: { [weak self] in
                if self != nil {
                    self?.callbackUpdateView(request, newProduct)
                }
            }) // end callback to main
        } // end fetch Products
    }
    
    private func callbackUpdateView(_ request: EmagRequest, _ newProduct: Product) {
        if let lastRequest = self.lastEmagAPIRequest, request == lastRequest {
            if !(self.products.contains(newProduct)) {
                let index = self.products.count
                self.products.insert(newProduct, at: index)
                
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                self.tableView.endUpdates()
                
                self.tableView.separatorStyle = .singleLine
                self.activityIndicatorView.stopAnimating()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
        searchForProducts()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView:
            makeEmagNavigationButton(touchAction: #selector(leftBarButtonItemTapped),
                                     customEdgeInset: UIEdgeInsetsMake(-1, -50, 1, 1)))
        
        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicatorView.hidesWhenStopped = true
        tableView.backgroundView = activityIndicatorView
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        tableView.separatorStyle = .none
        activityIndicatorView.startAnimating()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: productIdentifier, for: indexPath)
        let product: Product = products[indexPath.row]
        
        if let productCell = cell as? ProductTableViewCell {
            productCell.product = product
        }
        
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let indexPath = tableView.indexPathForSelectedRow {
            let product = self.products[indexPath.row]
            if segue.identifier == idSegueToDetails,
                let productDetalisViewController = segue.destination as? ProductDetailsViewController
            {
                DispatchQueue.global(qos: .background).async {
                    self.lastEmagAPIRequest!.setProductDetails(product: product)
                    productDetalisViewController.productDetails = product.productDetails
                }
            }
            else if segue.identifier == idSegueToImages,
                let imagesVC = segue.destination as? ImageSliderViewController
            {
                DispatchQueue.global(qos: .background).async {
                    // get details; need only urls, but the overhead is minuscule.
                    self.lastEmagAPIRequest!.setProductDetails(product: product)
                    imagesVC.imageUrls = product.productDetails?.largeImageUrls
                    print(" >> from TableView[\(indexPath.row)] to images with \(product.productDetails?.largeImageUrls?.count ?? 0 ) image URLs.")
                }
            }
        }
    }
    
    @objc func leftBarButtonItemTapped() {
        dismiss(animated: true, completion: nil)
    }
}
