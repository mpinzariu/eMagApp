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
    
    private var lastEmagAPIRequest: EmagAPIRequest?
    private var activityIndicatorView: UIActivityIndicatorView!
    private var products: [Product] = []
    
    var searchText: String? {
        didSet {            
            products.removeAll()
            title = searchText
        }
    }

    private func emagRequest() -> EmagAPIRequest? {
        if lastEmagAPIRequest != nil {
            return lastEmagAPIRequest
        }
        
        if let searchText = searchText, !searchText.isEmpty {
            return EmagAPIRequest(search: searchText)
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
    
    private func asyncLoad(_ request: EmagAPIRequest) {
        self.lastEmagAPIRequest!.downloadHTML()
        request.fetchProducts { [unowned self] newProduct in
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: { [weak self] in
                if self != nil {
                    self?.callbackUpdateView(request, newProduct)
                }
            }) // end callack to main
        } // end fetch Products
    }
    
    private func callbackUpdateView(_ request: EmagAPIRequest, _ newProduct: Product) {
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
        
        setupNavigationBarItems()
        
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

        // Configure the cell...
        let product: Product = products[indexPath.row]
        
        if let productCell = cell as? ProductTableViewCell {
            productCell.product = product
        }
        
        return cell
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == idSegueToDetails,
            let productDetalisViewController = segue.destination as? ProductDetalisViewController,
            let indexPath = tableView.indexPathForSelectedRow
        {
            DispatchQueue.global(qos: .background).async {                
                self.lastEmagAPIRequest!.setProductDetails(product: self.products[indexPath.row])
                productDetalisViewController.productDetails = self.products[indexPath.row].productDetails
            }
        }
    }
    
    private func setupNavigationBarItems() {
        let buttonLeft =  UIButton(type: .custom)
        buttonLeft.setImage(UIImage(named: "logoEmag16"), for: .normal)
        buttonLeft.addTarget(self, action: #selector(leftBarButtonItemTapped), for: .touchUpInside)
        buttonLeft.frame = CGRect(x: 0, y: 0, width: 50, height: 31)
        buttonLeft.imageEdgeInsets = UIEdgeInsetsMake(-1, -50, 1, 1) //move image to the right
        
        let barButtonLeft = UIBarButtonItem(customView: buttonLeft)
        self.navigationItem.leftBarButtonItem = barButtonLeft
    }
    
    @objc func leftBarButtonItemTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
