//
//  GgLocation+CoreDataProperties.swift
//  googlePlaceSearch
//
//  Created by remotetiger on 3/12/17.
//  Copyright © 2017 TamNguyen. All rights reserved.
//

import Foundation
import CoreData


extension GgLocation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GgLocation> {
        return NSFetchRequest<GgLocation>(entityName: "GgLocation");
    }

    @NSManaged public var name: String
    @NSManaged public var place_id: String
    @NSManaged public var lat: Double
    @NSManaged public var lng: Double
    @NSManaged public var rating: Float
    @NSManaged public var price: String
    @NSManaged public var vacinity: String
    @NSManaged public var iconUrlStr: String
    @NSManaged public var ggLocationList: GgLocationList?

}
