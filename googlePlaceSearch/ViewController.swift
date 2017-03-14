//
//  ViewController.swift
//  googlePlaceSearch
//
//  Created by remotetiger on 3/12/17.
//  Copyright © 2017 TamNguyen. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var resultsContainer: UIView!
    @IBOutlet weak var resultsContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var chromeView: UIView!
    
    @IBAction func navigateToCurrentLocation(_ sender: Any) {
        LocationManager.startDiscovery()
    }
    
    fileprivate static let mapViewDelegate = CustomMapViewDelegate()
    fileprivate var resultsNav: UINavigationController?
    fileprivate let resultsVC = ResultsViewController()
    
    // changing viewMode will animate the resultsView
    fileprivate var viewMode: ViewMode? {
        didSet {
            setupView(forViewMode: viewMode!)
            
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut], animations: { [weak self] in
                self?.view.layoutIfNeeded()
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        UIApplication.shared.statusBarStyle = .default
        
        // stylizing view
        resultsContainer.layer.shadowOffset = .zero
        resultsContainer.layer.shadowRadius = 3
        resultsContainer.layer.shadowOpacity = 0.6
        
        mapView.showsUserLocation = true
        mapView.delegate = ViewController.mapViewDelegate
        
        // callback when an annotation is selected
        ViewController.mapViewDelegate.showDetails = { [weak self] place_id in
            self?.showDetailsForPlaceId(place_id)
        }
        
        // setup views
        setupView(forViewMode: .mapView)
        setupResultsViewController()
        setupLocationManager()
        
        // add tapgesture to chromeView
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideChromeView))
        chromeView.addGestureRecognizer(tapGesture)
    }
}

extension ViewController {
    
    // start locations discovery and focus on user's location
    fileprivate func setupLocationManager() {
        LocationManager.startDiscovery()
        LocationManager.locationDidUpdate = { [weak self] center in
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: center, span: span)
            
            dispatchMainAsync {
                self?.mapView.setRegion(region, animated: true)
            }
        }
    }
    
    // setup results viewController
    fileprivate func setupResultsViewController() {
        self.resultsNav = UINavigationController(rootViewController: resultsVC)
        resultsNav?.isNavigationBarHidden = true
        
        // toggle viewMode
        resultsVC.toggleViewMode = { [weak self] expand in
            self?.viewMode = expand ? .searchView : .mapView
        }
        
        // // select annotation on mapView and show location details
        resultsVC.selectedPlaceId = { [weak self] placeId in
            self?.selectAnnotation(forPlaceId: placeId)
        }
        
        // add annotations on mapView for found locations
        resultsVC.foundLocations = { [weak self] locations in
            self?.addAnnotations(forLocations: locations)
        }
        
        setViewController(self.resultsNav, inContainer: resultsContainer)
    }
}

extension ViewController {
    
    // select annotation for place_id
    fileprivate func selectAnnotation(forPlaceId placeId: String) {
        let selectedAnn = mapView.annotations.first { ($0 as? CustomPointAnnotation)?.place_id == placeId }
        if let selected = selectedAnn {
            mapView.selectAnnotation(selected, animated: true)
        }
    }
    
    // show delails for the selected place_id
    fileprivate func showDetailsForPlaceId(_ placeId: String) {
        let detailsVC = DetailsViewController()
        self.resultsNav?.pushViewController(detailsVC, animated: true)

        if var navChild = self.resultsNav?.viewControllers, navChild.count > 2 {
            navChild.remove(at: 1)
            self.resultsNav?.viewControllers = navChild
        }
        
        // change viewMode to detailsView
        viewMode = .detailsView
        
        // request for location details
        GooglePlaces.shared.getDetails(placeId: placeId) { details, error in
            guard let details = details else { return }
            
            dispatchMainAsync {
                detailsVC.loadViewIfNeeded()        // make sure details viewController is loaded
                detailsVC.setDetails(details)       // setup location details
            }
        }
        
        // select annotation on mapView
        selectAnnotation(forPlaceId: placeId)
    }
    
    // add annotations on mapView
    fileprivate func addAnnotations(forLocations locations: [GoogleLocation]) {
        LocationManager.startDiscovery()
        // remove existing annotaions
        self.mapView.removeAnnotations(self.mapView.annotations)
        
        // add new annotations
        for loc in locations {
            guard let lat = loc.lat, let lng = loc.lng else { continue }
            let annotation = CustomPointAnnotation()
            annotation.place_id = loc.place_id
            annotation.title = loc.name
            annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            self.mapView.addAnnotation(annotation)
        }
    }
    
    // hide chromeView when it is tapped
    @objc fileprivate func hideChromeView() {
        resultsVC.toggleButtonTapped(nil)
    }
    
    // enable chromeView
    fileprivate func enableChromeView(_ enable: Bool) {
        chromeView.isUserInteractionEnabled = enable
        let alpha: CGFloat = enable ? 0.3 : 0.0
        
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut], animations: { [weak self] in
            self?.chromeView.backgroundColor = UIColor.black.withAlphaComponent(alpha)
        }) { [weak self] complete in
            self?.chromeView.backgroundColor = UIColor.black.withAlphaComponent(alpha)
        }
    }
    
    // different viewMode. animate the resultViews container height
    fileprivate func setupView(forViewMode mode: ViewMode) {
        switch mode {
        case .mapView:
            enableChromeView(false)
            resultsContainerHeightConstraint.constant = 50
        case .detailsView:
            enableChromeView(false)
            resultsContainerHeightConstraint.constant = 200
        case .searchView:
            enableChromeView(true)
            resultsContainerHeightConstraint.constant = UIView.deviceHeight - 70
        }
    }
}
