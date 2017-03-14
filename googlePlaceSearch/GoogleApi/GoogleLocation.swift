//
//  GoogleLocation.swift
//  googlePlaceSearch
//
//  Created by remotetiger on 3/12/17.
//  Copyright © 2017 TamNguyen. All rights reserved.
//

import Foundation
import MapKit

//{
//    geometry =     {
//        location =         {
//            lat = "37.7840782";
//            lng = "-122.407668";
//        };
//        viewport =         {
//            northeast =             {
//                lat = "37.7854271802915";
//                lng = "-122.4063190197085";
//            };
//            southwest =             {
//                lat = "37.7827292197085";
//                lng = "-122.4090169802915";
//            };
//        };
//    };
//    icon = "https://maps.gstatic.com/mapfiles/place_api/icons/cafe-71.png";
//    id = b7e49507cff97519826981411c6ed345c03859a3;
//    name = Starbucks;
//    "opening_hours" =     {
//        "exceptional_date" =         (
//        );
//        "open_now" = 0;
//        "weekday_text" =         (
//        );
//    };
//    photos =     (
//        {
//            height = 3024;
//            "html_attributions" =             (
//                "<a href=\"https://maps.google.com/maps/contrib/113305919995230455128/photos\">Alex</a>"
//            );
//            "photo_reference" = "CoQBdwAAAOoymQkhHZxV10TebcnxrZASXJiI1fHRnD8yoQMSmEZaQiPzMcR74UHcvzAr2b8ND9yfjajNSgTyUPiyNOV3HQwXoH6GqFnd56z2sW7VkPVCLHbqJrr6D1JV2omfZtZBRCbw9qToxyTlpjS8KaPTRFfN20U1YoEd_3oNQWsIyLJAEhAChrnC7wPHWvqE_8_HIaA2GhRdvB9Yre8SmMYTNmX5aGgOMNOthA";
//            width = 4032;
//        }
//    );
//    "place_id" = ChIJrZxI34WAhYARLlHHWVCHXa4;
//    "price_level" = 2;
//    rating = "3.7";
//    reference = "CmRSAAAAtkmhrl31tEfP_sfekwMr2u5SI8g1yOm55sUKoGfVc6M7ezanY8XWqlKO17FIIhBsb4KTLqEoUPdVpKPw-35s0fAYMEmMRBpyLeVVxwclqQDBUvpF_5kyTR3dDh5cJyR5EhCp6w8rcRCEgpuJT5bX0mmkGhSgzpQP4UipCPf8WwX__l2BhliszA";
//    scope = GOOGLE;
//    types =     (
//        cafe,
//        food,
//        store,
//        "point_of_interest",
//        establishment
//    );
//    vicinity = "865 Market Street, C 26A, San Francisco";
//}

public class GoogleLocation {
    fileprivate let dict: NSDictionary?
    fileprivate var ggLocation: GgLocation? = nil
    
    fileprivate(set) lazy var name: String? = {
        if let name = self.ggLocation?.name { return name }
        let name = self.dict?["name"] as? String
        return name
    }()
    
    fileprivate(set) lazy var place_id: String? = {
        if let place_id = self.ggLocation?.place_id { return place_id }
        let place_id = self.dict?["place_id"] as? String
        return place_id
    }()
    
    fileprivate(set) lazy var iconUrl: URL? = {
        if let urlStr = self.ggLocation?.iconUrlStr, let url = URL(string: urlStr) { return url }
        guard let iconStr = self.dict?["icon"] as? String else { return nil }
        return URL(string: iconStr)
    }()
    
    fileprivate(set) lazy var rating: Float? = {
        if let rating = self.ggLocation?.rating { return rating }
        guard let rating = self.dict?["rating"] as? Float else { return nil }
        return rating
    }()
    
    fileprivate(set) lazy var price: String? = {
        if let price = self.ggLocation?.price { return price }
        guard let price = self.dict?["price_level"] as? Int else { return nil }
        return String(repeating: "$", count: price)
    }()
    
    fileprivate(set) lazy var vacinity: String? = {
        if let vacinity = self.ggLocation?.vacinity { return vacinity }
        guard let vacitiny = self.dict?["vicinity"] as? String else { return nil }
        return vacitiny
    }()
    
    fileprivate(set) lazy var openingNow: Bool? = {
        guard let openingHours = self.dict?["opening_hours"] as? NSDictionary else { return nil }
        guard let openingNow = openingHours["open_now"] as? Bool else { return nil }
        return openingNow
    }()
    
    fileprivate(set) lazy var lng: Double? = {
        if let lng = self.ggLocation?.lng { return lng }
        let geometry = self.dict?["geometry"] as? [String: Any]
        let location = geometry?["location"] as? [String: Any]
        let name = self.dict?["name"] as? String
        guard let lng = location?["lng"] as? Double else { return nil }
        return lng
    }()
    
    fileprivate(set) lazy var lat: Double? = {
        if let lat = self.ggLocation?.lat { return lat }
        let geometry = self.dict?["geometry"] as? [String: Any]
        let location = geometry?["location"] as? [String: Any]
        let name = self.dict?["name"] as? String
        guard let lat = location?["lat"] as? Double else { return nil }
        return lat
    }()
    
    init(dict: NSDictionary) {
        self.dict = dict
    }
    
    init(dbObject: GgLocation) {
        self.dict = nil
        self.ggLocation = dbObject
    }
}

extension GoogleLocation: CustomStringConvertible, Hashable, Equatable {
    public var description: String {
        return "<Location: \(name)>"
    }
    
    public var hashValue: Int {
        return description.hashValue
    }
}

public func ==(lhs: GoogleLocation, rhs: GoogleLocation) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

public class GoogleLocationList {
    fileprivate var json: [String: Any]? = nil
    fileprivate var _storedLocations: [GoogleLocation]? = nil
    
    fileprivate(set) lazy var locations: [GoogleLocation]? = {
        if let storedLocation = self._storedLocations { return storedLocation }
        guard let array = self.json?["results"] as? Array<NSDictionary> else { return nil }
        return array.map { GoogleLocation(dict: $0) }
    }()
    
    init(data: Data) {
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else { return }
        self.json = json
    }
    
    init?(dbObject: GgLocationList) {
        self.json = nil
        guard let array = dbObject.ggLocations?.allObjects as? [GgLocation] else { return nil }
        self._storedLocations = array.map { GoogleLocation(dbObject: $0) }
    }
}
