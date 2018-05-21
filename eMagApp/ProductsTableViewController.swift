//
//  TestTableViewController.swift
//  TestTableViewApp2
//
//  Created by Pinzariu Marian on 25/04/2018.
//  Copyright © 2018 Pinzariu Marian. All rights reserved.
//

import UIKit

class ProductsTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    private let cellIdentifier = "cell"
    private let productIdentifier = "Product"
    private let idSegueToDetails = "ShowProductDetails"
    private let idSegueToImages = "ShowImageSlider"
    
    private var lastEmagProductRequest: EmagProductsRequest?
    private var lastEmagDetailsRequest: EmagDetailsRequest?
    private var activityIndicatorView: UIActivityIndicatorView!
    private var products: [Product] = []
    
    var searchText: String? {
        didSet {            
            products.removeAll()
            title = searchText
        }
    }

    private func emagRequest() -> EmagProductsRequest? {
        if lastEmagProductRequest != nil {
            return lastEmagProductRequest
        }
        
        if let searchText = searchText, !searchText.isEmpty {
            return EmagProductsRequest(search: searchText)
        }
        
        return nil
    }
    
    // MARK: - Page Lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
        searchForProducts()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView:
            makeEmagNavigationButton(customEdgeInset: UIEdgeInsetsMake(-1, -50, 1, 1)))
        
        activityIndicatorView = makeActivityIndicator()
        tableView.backgroundView = activityIndicatorView
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        tableView.separatorStyle = .none
        activityIndicatorView.startAnimating()
    }

    // MARK : - TableView.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: productIdentifier, for: indexPath)
        let product: Product = products[indexPath.row]
        
        if let productCell = cell as? ProductTableViewCell  {
            if productCell.delegate == nil {
                productCell.delegate = ProductCellDelegate()
                productCell.delegate?.updateUI(productCell, product, launchSegueToImages(_:))
            }
        }
        
        return cell
    }
    
    // MARK: - Load Products
    
    private func searchForProducts() {
        if let request = emagRequest() {
            lastEmagProductRequest = request
            
            tableView.separatorStyle = .none
            activityIndicatorView.startAnimating()
            
            DispatchQueue.global(qos: .userInteractive).async {
                [weak self] in self?.asyncLoad(request)
            }
        }
    }
    
    private func asyncLoad(_ request: EmagProductsRequest) {
        request.fetchProducts { [unowned self] newProduct in
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: { [weak self] in
                if self != nil {
                    self?.callbackUpdateView(request, newProduct)
                }
            }) // end callback to main
        } // end fetch Products
    }
    
    private func callbackUpdateView(_ request: EmagRequest, _ newProduct: Product) {
        if let lastRequest = self.lastEmagProductRequest, request == lastRequest {
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
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let indexPath = tableView.indexPathForSelectedRow {
            let product = self.products[indexPath.row]
            if segue.identifier == idSegueToDetails,
                let productDetailsViewController = segue.destination as? ProductDetailsViewController
            {
                DispatchQueue.global(qos: .background).async {
                    self.lastEmagDetailsRequest = EmagDetailsRequest(product: product)
                    self.lastEmagDetailsRequest!.setProductDetails()
                    productDetailsViewController.productDetails = product.productDetails
                }
            }
        }
        
        if segue.identifier == idSegueToImages,
            let imagesVC = segue.destination as? ImageSliderViewController,
            let product = sender as? Product
        {
            DispatchQueue.global(qos: .background).async {
                // get details; need only urls, but the overhead is minuscule.
                self.lastEmagDetailsRequest = EmagDetailsRequest(product: product)
                self.lastEmagDetailsRequest!.setProductDetails()
                imagesVC.imageUrls = product.productDetails?.largeImageUrls
            }
        }
    }
    
    private func launchSegueToImages(_ product: Product) {
        performSegue(withIdentifier: idSegueToImages, sender: product)
    }
}
