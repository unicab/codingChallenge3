
//
//  GoogleLocationDetail.swift
//  googlePlaceSearch
//
//  Created by remotetiger on 3/13/17.
//  Copyright © 2017 TamNguyen. All rights reserved.
//

import Foundation

public class GoogleLocationDetails {
    fileprivate var dict: [String: Any]? = nil
    
    fileprivate(set) lazy var name: String? = {
        let name = self.dict?["name"] as? String
        return name
    }()
    
    fileprivate(set) lazy var streetAddress: String? = {
        guard let address = self.dict?["formatted_address"] as? String else { return nil }
        var comps: [String] = address.components(separatedBy: ",")
        for i in 1...3 { comps.removeLast() }
        return comps.joined(separator: " ")
    }()
    
    fileprivate(set) lazy var cityAndZip: String? = {
        guard let address = self.dict?["formatted_address"] as? String else { return nil }
        let comps: [String] = address.components(separatedBy: ",").reversed()
        guard comps.count > 3 else { return nil }
        return comps[2] + comps[1] + comps[0]
    }()
    
    fileprivate(set) lazy var website: String? = {
        guard let website = self.dict?["website"] as? String else { return nil }
        return website
    }()
    
    fileprivate(set) lazy var phoneNumber: String? = {
        guard let phone = self.dict?["formatted_phone_number"] as? String else { return nil }
        return phone
    }()
    
    fileprivate(set) lazy var price: String? = {
        guard let price = self.dict?["price_level"] as? Int else { return nil }
        return String(repeating: "$", count: price)
    }()
    
    fileprivate(set) lazy var rating: Float? = {
        guard let rating = self.dict?["rating"] as? Float else { return nil }
        return rating
    }()
    
    fileprivate(set) lazy var reviewsCount: Int? = {
        guard let reviews = self.dict?["reviews"] as? NSArray else { return nil }
        return reviews.count
    }()
    
    init(data: Data) {
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else { return }
        self.dict = json?["result"] as? [String : Any]
    }
}

extension GoogleLocationDetails: CustomStringConvertible {
    public var description: String {
        return "<Details: \(streetAddress)>"
    }
}
