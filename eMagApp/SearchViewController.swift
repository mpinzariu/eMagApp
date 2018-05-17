//
//  SearchViewController.swift
//  TestTableViewApp2
//
//  Created by Pinzariu Marian on 02/05/2018.
//  Copyright © 2018 Pinzariu Marian. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    private let idSegueToResults: String = "ShowSearchResults"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.delegate = self
        searchTextField.returnKeyType = .done
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if identifier == idSegueToResults, (searchTextField.text?.count)! <= 2 {
            showWarning(title: "Search warning",
                        message: "The length of the search text must be at least with 3 characters!")
            return false
        }
        return true
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {        
        if segue.identifier == idSegueToResults,
            let navigationController = segue.destination as? UINavigationController,
            let tableViewController = navigationController.viewControllers.first as? ProductsTableViewController
        {
            tableViewController.searchText = searchTextField.text
        }
    }
    
}


extension SearchViewController :  UITextFieldDelegate  {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        performSegue(withIdentifier: idSegueToResults, sender: self)
        return true
    }
}
