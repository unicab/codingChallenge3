//
//  DispatchQueue.swift
//  googlePlaceSearch
//
//  Created by remotetiger on 3/12/17.
//  Copyright © 2017 TamNguyen. All rights reserved.
//

import Foundation


public func dispatchMainAsync(_ block: @escaping () -> Void) {
    DispatchQueue.main.async(execute: block)
}

fileprivate let myQueue = DispatchQueue(label: "myQueue", qos: .default, attributes: .concurrent)
public func dispatchAsync(queue: DispatchQueue = myQueue, execute block: @escaping ()->Void) {
    queue.async(execute: block)
}
