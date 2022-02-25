//
//  ButtonExtension.swift
//  Klikdokter
//
//  Created by Hai Hoang on 25/02/2022.
//

import UIKit

extension UIButton {
    func setBtnEnabled(_ enabled: Bool) {
        if enabled {
            self.isUserInteractionEnabled = true
            self.alpha = 1.0
        } else {
            self.isUserInteractionEnabled = false
            self.alpha = 0.2
        }
    }
}
