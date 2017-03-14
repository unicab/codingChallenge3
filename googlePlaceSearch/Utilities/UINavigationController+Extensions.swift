//
//  UINavigationController+Extensions.swift
//  googlePlaceSearch
//
//  Created by remotetiger on 3/14/17.
//  Copyright © 2017 TamNguyen. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    
    // push viewController with completion block
    public func pushViewController(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }
}
