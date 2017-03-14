//
//  MapViewComponents.swift
//  googlePlaceSearch
//
//  Created by remotetiger on 3/13/17.
//  Copyright © 2017 TamNguyen. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class CustomPointAnnotation: MKPointAnnotation {
    var place_id: String? = nil
}

class CustomMapViewDelegate: NSObject, MKMapViewDelegate {
    
    var showDetails: ((_ place_id: String) -> Void)?
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        LocationManager.stopDiscovery()
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let custom = view.annotation as? CustomPointAnnotation else { return }
        guard let place_id = custom.place_id else { return }
        showDetails?(place_id)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annId = "ann"
        var annView = mapView.dequeueReusableAnnotationView(withIdentifier: annId)
        
        if annView == nil {
            annView = MKAnnotationView(annotation: annotation, reuseIdentifier: annId)
            annView?.canShowCallout = true
            let image = (annotation is CustomPointAnnotation) ? #imageLiteral(resourceName: "starbucks1") : #imageLiteral(resourceName: "location")
            annView?.image = image.resize(CGSize(width: 30, height: 30))
        } else {
            annView?.annotation = annotation
        }
        
        return annView
    }
    

}
