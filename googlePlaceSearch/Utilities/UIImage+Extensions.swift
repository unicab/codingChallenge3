//
//  UIImage+Extensions.swift
//  googlePlaceSearch
//
//  Created by remotetiger on 3/13/17.
//  Copyright © 2017 TamNguyen. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    public func resize(_ size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        self.draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
}
