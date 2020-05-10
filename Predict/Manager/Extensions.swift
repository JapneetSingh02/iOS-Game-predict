//
//  Extensions.swift
//  Predict
//
//  Created by Japneet Singhl on 19/02/20.
//  Copyright © 2020 Japneet Singhl. All rights reserved.
//

import UIKit

extension UIView {

    /**
     Rotate a view by specified degrees

     - parameter angle: angle in degrees
     */
    func rotate(angle: CGFloat) {
        let radians = angle / 180.0 * CGFloat.pi
        let rotation = self.transform.rotated(by: radians);
        self.transform = rotation
    }

}
