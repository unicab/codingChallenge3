//
//  googlePlaceSearchTests.swift
//  googlePlaceSearchTests
//
//  Created by remotetiger on 3/12/17.
//  Copyright © 2017 TamNguyen. All rights reserved.
//

import XCTest
import MapKit
import CoreData
@testable import googlePlaceSearch

class MockAppDelegate: NSObject, UIApplicationDelegate {
}

class googlePlaceSearchTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        UIApplication.shared.delegate = MockAppDelegate()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
//        let sema = DispatchSemaphore(value: 0)
//        
//        let abc = GooglePlaces()
//        let location = CLLocationCoordinate2D(latitude: -33.8670522, longitude: 151.1957362)
//        
//        abc.search(location: location, radius: 500, query: "cruise") { (locationList, error) -> Void in
//            guard let locationList: GoogleLocationList = locationList else { return }
//            
//            try? CoreDataStorage.save(locationList: locationList)
//            try? CoreDataStorage.fetchData()
//            sema.signal()
//        }
//        
//        sema.wait()
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
