//
//  ScrollView+removeAllSubviews.swift
//  eMagApp
//
//  Created by Elizabeta Macovei on 15/05/2018.
//  Copyright © 2018 Pinzariu Marian. All rights reserved.
//

import Foundation
import UIKit

extension UIScrollView {
    
    func removeAllSubviews() {
        for subView in self.subviews {
            subView.removeFromSuperview()
        }
    }
}
