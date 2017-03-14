//
//  CoreDataStorage.swift
//  googlePlaceSearch
//
//  Created by remotetiger on 3/12/17.
//  Copyright © 2017 TamNguyen. All rights reserved.
//

import Foundation
import CoreData
import UIKit

public enum CoreDataStorageError: Error {
    case invalidEntity
    case missingLocations
    case fetchFailed
}

public class CoreDataStorage {
    private init() { }
    
    // managedContext object
    public static var managedContext: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.persistentContainer.viewContext
        return managedContext
    }
    
    // save data to coreData
    public static func save(locationList: GoogleLocationList) throws {
        guard let locations = locationList.locations else { throw CoreDataStorageError.missingLocations }
        
        var locObjects: [NSManagedObject] = []
    
        // create array of locationObjects
        for loc in locations {
            guard let locEntity = NSEntityDescription.entity(forEntityName: "GgLocation", in: managedContext) else { continue }
            let locObject = NSManagedObject(entity: locEntity, insertInto: managedContext)
            
            locObject.setValue(loc.name, forKey: "name")
            locObject.setValue(loc.place_id, forKey: "place_id")
            locObject.setValue(loc.lat, forKey: "lat")
            locObject.setValue(loc.lng, forKey: "lng")
            locObject.setValue(loc.rating, forKey: "rating")
            locObject.setValue(loc.price, forKey: "price")
            locObject.setValue(loc.vacinity, forKey: "vacinity")
            locObject.setValue(loc.iconUrl?.absoluteString, forKey: "iconUrlStr")
            locObjects.append(locObject)
        }
        
        // store locationObjects in locationList object
        guard let locListEntity = NSEntityDescription.entity(forEntityName: "GgLocationList", in: managedContext) else { throw CoreDataStorageError.invalidEntity }
        let locListObject = NSManagedObject(entity: locListEntity, insertInto: managedContext)
        
        let locs = NSSet(array: locObjects)
        locListObject.setValue(locs, forKey: "ggLocations")
        
        do {
            // save data
            try managedContext.save()
        } catch {
            throw error
        }
    }
    
    // fetch stored data in coreData
    public static func fetchData() throws -> GoogleLocationList? {
        // print location of the coreData file
        if let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            print(documentsUrl.absoluteString)
        }
        
        // create fetch request for ggLocationList entity
        guard let locListEntity = NSEntityDescription.entity(forEntityName: "GgLocationList", in: managedContext) else { throw CoreDataStorageError.invalidEntity }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = locListEntity
        
        do {
            // returned the fetched data
            guard let result = try managedContext.fetch(fetchRequest).first as? GgLocationList else { throw CoreDataStorageError.fetchFailed }
            let locationList = GoogleLocationList(dbObject: result)
            return locationList
        } catch {
            throw error
        }
    }
    
    // delete stored data in coreData
    public static func deleteData() throws {
        // delete fetch request for ggLocationList entity
        let fetchRequest1 = NSFetchRequest<NSFetchRequestResult>(entityName: "GgLocationList")
        let batchDeleteRequest1 = NSBatchDeleteRequest(fetchRequest: fetchRequest1)
        
        // delete fetch request for ggLocation entity
        let fetchRequest2 = NSFetchRequest<NSFetchRequestResult>(entityName: "GgLocation")
        let batchDeleteRequest2 = NSBatchDeleteRequest(fetchRequest: fetchRequest2)
        
        do {
            // execute delete requests
            try managedContext.execute(batchDeleteRequest1)
            try managedContext.execute(batchDeleteRequest2)
        } catch {
            throw error
        }
    }
}
