//
//  GoogleSuff.swift
//  googlePlaceSearch
//
//  Created by remotetiger on 3/12/17.
//  Copyright © 2017 TamNguyen. All rights reserved.
//
//  GooglePlaces.swift
//

import CoreLocation
import Foundation
import MapKit
import CoreData
import UIKit

//https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=-33.8670522,151.1957362&radius=500&types=food&name=cruise&key=AIzaSyAwriPv37X_r9LFCNutThVY2PntUjoTEjo
//https://maps.googleapis.com/maps/api/place/details/json?placeid=ChIJrZxI34WAhYARLlHHWVCHXa4&key=AIzaSyAwriPv37X_r9LFCNutThVY2PntUjoTEjo

public class GooglePlaces {
    public static let shared = GooglePlaces()
    
    fileprivate let SEARCH = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
    fileprivate let LOCATION = "location="
    fileprivate let RADIUS = "radius="
    
    fileprivate let DETAILS = "https://maps.googleapis.com/maps/api/place/details/json?"
    fileprivate let PLACEID = "placeid="
    
    // get key from plist file
    fileprivate static var key: String? {
        guard let path = Bundle.main.path(forResource: "google", ofType: "plist") else { return nil }
        return NSDictionary(contentsOfFile: path)?["places-key"] as? String
    }

    fileprivate init() { }

    // ------------------------------------------------------------------------------------------
    // Google Places search with callback
    // ------------------------------------------------------------------------------------------
    func search(location: CLLocationCoordinate2D, radius: Int, query: String,
        completion: @escaping (GoogleLocationList?, Error?) -> Void) {
        guard let key = GooglePlaces.key else {
            completion(nil, NetworkRequestError.invalidKey)
            return
        }
        
        let urlEncodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let urlString = "\(SEARCH)\(LOCATION)\(location.latitude),\(location.longitude)&\(RADIUS)\(radius)&key=\(key)&name=\(urlEncodedQuery)"
        print("Request for URL \(urlString)")
        guard let url = URL(string: urlString) else { completion(nil, NetworkRequestError.invalidURL); return }
        
        let task = NetworkRequest.dataTask(url) { data, response, error in
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(nil, NetworkRequestError.badResponse)
                return
            }
            
            guard response.statusCode == 200 else {
                completion(nil, NetworkRequestError.failedWithCode(response.statusCode))
                return
            }
            
            guard let data = data else {
                completion(nil, NetworkRequestError.missingData)
                return
            }
            
            let ggList = GoogleLocationList(data: data)
            completion(ggList, nil)
        }
        
        task.resume()
    }
    
    func getDetails(placeId id: String, completion: @escaping (GoogleLocationDetails?, Error?) -> Void) {
        guard let key = GooglePlaces.key else {
            completion(nil, NetworkRequestError.invalidKey)
            return
        }

        let urlString = "\(DETAILS)\(PLACEID)\(id)&key=\(key)"
        guard let url = URL(string: urlString) else { completion(nil, NetworkRequestError.invalidURL); return }
        print("Request for URL \(urlString)")
        
        let task = NetworkRequest.dataTask(url) { data, response, error in
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(nil, NetworkRequestError.badResponse)
                return
            }
            
            guard response.statusCode == 200 else {
                completion(nil, NetworkRequestError.failedWithCode(response.statusCode))
                return
            }
            
            guard let data = data else {
                completion(nil, NetworkRequestError.missingData)
                return
            }
            
            let details = GoogleLocationDetails(data: data)
            completion(details, nil)
        }
        
        task.resume()
    }
}
