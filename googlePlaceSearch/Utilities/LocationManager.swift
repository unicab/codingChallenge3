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
    
    fileprivate static var defaultManager: CLLocationManager = {
        let locationMng = CLLocationManager()
        locationMng.delegate = delegate
        locationMng.desiredAccuracy = kCLLocationAccuracyHundredMeters
        return locationMng
    }()
    
    fileprivate static let delegate = LocationManagerDelegate()
    
    public static var locationDidUpdate: ((CLLocationCoordinate2D) -> Void)?
    fileprivate var locationDiscoveryTimer: Timer?
    fileprivate(set) static var currentLocation: CLLocationCoordinate2D?
    
    fileprivate init() { }
    
}

extension LocationManager {

    fileprivate func startDiscoveryTimer() {
        locationDiscoveryTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(LocationManager.startDiscovery), userInfo: nil, repeats: true)
    }
    
    fileprivate func stopDiscoveryTimer() {
        locationDiscoveryTimer?.invalidate()
    }
    
    @objc public static func startDiscovery() {
        guard CLLocationManager.locationServicesEnabled() && (CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse) else {
            defaultManager.requestWhenInUseAuthorization()
            return
        }
        
        stopDiscovery()
        defaultManager.startUpdatingLocation()
    }
    
    public static func stopDiscovery() {
        defaultManager.stopUpdatingLocation()
    }
    
}

class LocationManagerDelegate: NSObject, CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else { return }
        let lat = lastLocation.coordinate.latitude
        let lng = lastLocation.coordinate.longitude
        
        let center = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        LocationManager.currentLocation = center
        LocationManager.locationDidUpdate?(center)
    }
}
