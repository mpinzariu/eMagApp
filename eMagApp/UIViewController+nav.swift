//
//  UIViewController+nav.swift
//  eMagApp
//
//  Created by Elizabeta Macovei on 17/05/2018.
//  Copyright © 2018 Pinzariu Marian. All rights reserved.
//

import Foundation
import UIKit

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
