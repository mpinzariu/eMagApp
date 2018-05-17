//
//  UIImageView+.swift
//  eMagApp
//
//  Created by Elizabeta Macovei on 17/05/2018.
//  Copyright © 2018 Pinzariu Marian. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func loadImageUsingUrlString(urlString: String) {
        loadImageUsingUrlString(url: URL(string: urlString)!)
    }
    
    func loadImageUsingUrlString(url: URL) {
        self.image = nil
        if let imageFromCache = Cache.image.object(forKey: url.absoluteURL as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        
        URLSession.shared.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                DispatchQueue.main.async { [weak self] in
                    self?.image = #imageLiteral(resourceName: "noPicOnline")
                }
                print(error!)
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                let imageToCache = UIImage(data: data!)
                Cache.image.setObject(imageToCache!, forKey: url.absoluteURL as AnyObject)
                self?.image = imageToCache
            }
            
        }).resume()
    }
}
