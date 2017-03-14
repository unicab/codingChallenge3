//
//  LocationManager.swift
//  googlePlaceSearch
//
//  Created by remotetiger on 3/12/17.
//  Copyright © 2017 TamNguyen. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

public class LocationManager {
    
    // location manager object
    fileprivate static var defaultManager: CLLocationManager = {
        let locationMng = CLLocationManager()
        locationMng.delegate = delegate
        locationMng.desiredAccuracy = kCLLocationAccuracyHundredMeters
        return locationMng
    }()
    
    // callback when the location changed
    public static var locationDidUpdate: ((CLLocationCoordinate2D) -> Void)?
    
    fileprivate static let delegate = LocationManagerDelegate()             // delegate instance
    fileprivate(set) static var currentLocation: CLLocationCoordinate2D?    // current location
    fileprivate var locationDiscoveryTimer: Timer?                          // location timer
    
    fileprivate init() { }
}

extension LocationManager {
    
    // start locations discovery timer that repeatedly requesting for locations
    fileprivate func startDiscoveryTimer() {
        locationDiscoveryTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(LocationManager.startDiscovery), userInfo: nil, repeats: true)
    }
    
    // stop locations discovery timer
    fileprivate func stopDiscoveryTimer() {
        locationDiscoveryTimer?.invalidate()
    }
    
    // start discovery
    @objc public static func startDiscovery() {
        // check for authentication
        guard CLLocationManager.locationServicesEnabled() && (CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse) else {
            defaultManager.requestWhenInUseAuthorization()
            return
        }
        
        stopDiscovery()
        defaultManager.startUpdatingLocation()
    }
    
    // stop discovery
    public static func stopDiscovery() {
        defaultManager.stopUpdatingLocation()
    }
    
}

class LocationManagerDelegate: NSObject, CLLocationManagerDelegate {
    
    // get called when locations changed triggered
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else { return }
        let lat = lastLocation.coordinate.latitude
        let lng = lastLocation.coordinate.longitude
        
        let center = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        LocationManager.currentLocation = center        // update current location
        LocationManager.locationDidUpdate?(center)      // execute callback
    }
}
