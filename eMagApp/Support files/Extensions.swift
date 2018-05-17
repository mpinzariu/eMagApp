//
//  Extentions.swift
//  TestTableViewApp2
//
//  Created by Pinzariu Marian on 25/04/2018.
//  Copyright © 2018 Pinzariu Marian. All rights reserved.
//

import UIKit
import Foundation

extension Double {
    /// SwiftRandom extension
    public static func random(_ lower: Double = 0, _ upper: Double = 100) -> Double {
        return (Double(arc4random()) / 0xFFFFFFFF) * (upper - lower) + lower
    }
    
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    func format(_ f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}

extension String {
    static func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    var html2Attributed: NSAttributedString? {
        do {
            guard let data = data(using: String.Encoding.utf8) else {
                return nil
            }
            
            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print("error: ", error)
            return nil
        }
    }
}

extension UIViewController {
    func showWarning(title: String, message: String) {
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
}

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

extension UIViewController {
    func makeEmagNavigationButton(touchAction: Selector = #selector(onTapDismiss), customEdgeInset: UIEdgeInsets) -> UIButton {
        let buttonEmagLogo = UIButton(type: .custom)
        buttonEmagLogo.setImage(UIImage(named: "logoEmag16"), for: .normal)
        buttonEmagLogo.addTarget(self, action: touchAction, for: .touchUpInside)
        buttonEmagLogo.frame = CGRect(x: 0, y: 0, width: 50, height: 31)
        buttonEmagLogo.imageEdgeInsets = customEdgeInset
        return buttonEmagLogo
    }
    
    @objc private func onTapDismiss(){
        dismiss(animated: true, completion: nil)
    }
    
    func makeActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicatorView.color = UIColor.blue
        activityIndicatorView.hidesWhenStopped = true
        return activityIndicatorView
    }
    
}

public func log(_ whatToLog: String) {
    debugPrint("========================================================================================================")
    debugPrint("EmagAPIRequest: \(whatToLog)")
    debugPrint("========================================================================================================")
}

public typealias PropertyList = AnyObject
