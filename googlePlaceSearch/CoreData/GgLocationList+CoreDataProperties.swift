//
//  GgLocationList+CoreDataProperties.swift
//  googlePlaceSearch
//
//  Created by remotetiger on 3/12/17.
//  Copyright © 2017 TamNguyen. All rights reserved.
//

import Foundation
import CoreData


extension GgLocationList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GgLocationList> {
        return NSFetchRequest<GgLocationList>(entityName: "GgLocationList");
    }

    @NSManaged public var name: String?
    @NSManaged public var ggLocations: NSSet?

}

// MARK: Generated accessors for ggLocations
extension GgLocationList {

    @objc(addGgLocationsObject:)
    @NSManaged public func addToGgLocations(_ value: GgLocation)

    @objc(removeGgLocationsObject:)
    @NSManaged public func removeFromGgLocations(_ value: GgLocation)

    @objc(addGgLocations:)
    @NSManaged public func addToGgLocations(_ values: NSSet)

    @objc(removeGgLocations:)
    @NSManaged public func removeFromGgLocations(_ values: NSSet)

}
