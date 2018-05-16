//
//  ImageSliderViewController.swift
//  eMagApp
//
//  Created by Elizabeta Macovei on 14/05/2018.
//  Copyright © 2018 Pinzariu Marian. All rights reserved.
//

import UIKit

class ImageSliderViewController: UIViewController {
    
    // Image Carousel in UIScrollView - https://www.youtube.com/watch?v=LaWnv5sRpho
    
    //MARK: - Properties
    
    @IBOutlet weak var scrollImagesView: UIScrollView!
    var imageUrls: [URL]? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.updateUI()
            }
        }
    }
    private var activityIndicatorView: UIActivityIndicatorView!
    
    // MARK: - Page Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // navigation
        let btnGoToSearch = makeEmagNavigationButton(touchAction: #selector(onTapDismiss), customEdgeInset: UIEdgeInsetsMake(-1, 1, 1, -41))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btnGoToSearch)
        
        // activity
        activityIndicatorView = makeActivityIndicator()
        activityIndicatorView.center = view.center
        view.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
        
        // if imageUrls was set before loading/creating controls
        if imageUrls != nil {
            updateUI()
        }
    }
    
    @objc func onTapDismiss(){
        dismiss(animated: true, completion: nil)
    }
    
    func updateUI() {
        if scrollImagesView == nil {
            return
        }
        scrollImagesView.subviews.forEach({ $0.removeFromSuperview() })
        
        if let imageUrls = imageUrls {
            let totalImageCount = imageUrls.count
            scrollImagesView.contentSize.width = scrollImagesView.frame.width * CGFloat(totalImageCount)
            for  i in 0..<totalImageCount{
                let imgView = makeImageView(i)
                imgView.loadImageUsingUrlString(url: imageUrls[i])
                scrollImagesView.addSubview(imgView)
            }
        }
        else { // display 'no pictures available'
            scrollImagesView.contentSize.width = scrollImagesView.frame.width
            let imgView = makeImageView(0)
            imgView.image = #imageLiteral(resourceName: "noimage")
            scrollImagesView.addSubview(imgView)
        }
        updateTitle()
        activityIndicatorView.stopAnimating()
    }
    
    private func makeImageView(_ i: Int) -> UIImageView {
        let imgview = UIImageView()
        imgview.contentMode = .scaleAspectFit
        let xPos = self.view.frame.width * CGFloat(i)
        imgview.frame = CGRect(x: xPos, y: 0, width: self.scrollImagesView.frame.width, height: self.scrollImagesView.frame.height)
        return imgview
    }
    
    private func updateTitle() {
        if let imageUrls = imageUrls {
            let total = imageUrls.count
            self.title = total == 1 ? "1 image" : String("\(total) images")
        } else {
            self.title = "No images found"
        }
    }
}
