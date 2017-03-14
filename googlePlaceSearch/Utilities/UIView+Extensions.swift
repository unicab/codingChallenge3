//
//  UIView+Extensions.swift
//  googlePlaceSearch
//
//  Created by remotetiger on 3/12/17.
//  Copyright © 2017 TamNguyen. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    public static var deviceHeight: CGFloat {
        return max(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
    }
    
    public static var deviceWidth: CGFloat {
        return min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
    }
}
