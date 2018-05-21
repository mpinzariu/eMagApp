//
//  Double+random.swift
//  eMagApp
//
//  Created by Elizabeta Macovei on 17/05/2018.
//  Copyright © 2018 Pinzariu Marian. All rights reserved.
//

import Foundation

extension Double {
    func format(_ f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}
