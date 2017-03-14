//
//  NetworkRequest.swift
//  googlePlaceSearch
//
//  Created by remotetiger on 3/12/17.
//  Copyright © 2017 TamNguyen. All rights reserved.
//

import Foundation

public enum NetworkRequestError: Error {
    case badResponse
    case failedWithCode(Int)
    case invalidURL
    case missingData
    case invalidKey
}

public struct NetworkRequest {
    fileprivate static let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
    
    @discardableResult
    public static func dataTask(_ url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return defaultSession.dataTask(with: url, completionHandler: completion)
    }
}
