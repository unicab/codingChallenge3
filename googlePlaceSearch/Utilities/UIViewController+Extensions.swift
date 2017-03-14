//
//  UIVIewController+Extensions.swift
//  googlePlaceSearch
//
//  Created by remotetiger on 3/12/17.
//  Copyright © 2017 TamNguyen. All rights reserved.
//

import Foundation
import UIKit


extension UIViewController {
    
    public func setViewController(_ vc: UIViewController?, inContainer: UIView, insets: UIEdgeInsets = .zero) {
        guard let vc = vc else { return }
        
        self.childViewControllers.forEach {
            $0.viewIfLoaded?.removeFromSuperview()
            $0.willMove(toParentViewController: nil)
            $0.removeFromParentViewController()
        }
        
        inContainer.addSubview(vc.view)
        self.addChildViewController(vc)
        vc.didMove(toParentViewController: self)
        
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        vc.view.leadingAnchor.constraint(equalTo: inContainer.leadingAnchor, constant: insets.left).isActive = true
        vc.view.trailingAnchor.constraint(equalTo: inContainer.trailingAnchor, constant: insets.right).isActive = true
        vc.view.topAnchor.constraint(equalTo: inContainer.topAnchor, constant: insets.top).isActive = true
        vc.view.bottomAnchor.constraint(equalTo: inContainer.bottomAnchor, constant: insets.bottom).isActive = true
    }
}
