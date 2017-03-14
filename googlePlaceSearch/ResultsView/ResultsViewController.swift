//
//  ResultsViewController.swift
//  googlePlaceSearch
//
//  Created by remotetiger on 3/12/17.
//  Copyright © 2017 TamNguyen. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class ResultsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var toggleButton: UIButton!
    
    // callbacks and variable
    fileprivate var locations: [GoogleLocation] = []
    var selectedPlaceId: ((_ placeId: String) -> Void)?
    var foundLocations: (([GoogleLocation]) -> Void)?
    var toggleViewMode: ((_ expand: Bool) -> Void)?
    
    // search for starbucks locations
    @IBAction func searchButtonTapped(_ sender: Any) {
        self.searchForStarbucks()
    }
    
    // switching between different viewMode
    @IBAction func toggleButtonTapped(_ sender: Any?) {
        let expand = toggleButton.imageView?.image == #imageLiteral(resourceName: "upIcon")
        let image = expand ? #imageLiteral(resourceName: "closeIcon3") : #imageLiteral(resourceName: "upIcon")
        toggleButton.setImage(image, for: UIControlState())
        toggleViewMode?(expand)
    }
    
    init() {
        super.init(nibName: "ResultsView", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup tableView
        tableView.register(UINib(nibName: "ResultCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        
        do {
            // fetch data and setup locations on mapView
            let locationList = try CoreDataStorage.fetchData()
            setupLocations(fromLocationList: locationList)
        } catch {
            // if no data found search for starbucks near user's location
            searchForStarbucks()
        }
    }
}

extension ResultsViewController {
    
    // search for starbucks locations 
    fileprivate func searchForStarbucks() {
        self.search(key: "starbucks")
    }
    
    // search for location and store the respond
    fileprivate func search(key: String) {
        guard let curLocation = LocationManager.currentLocation else { return }
        
        // search request
        GooglePlaces.shared.search(location: curLocation, radius: 500, query: key) { [weak self] list, error in
            guard let list = list else { return }
            
            // store procedures
            dispatchMainAsync {
                try? CoreDataStorage.deleteData()               // delete current data
                try? CoreDataStorage.save(locationList: list)   // store new data
                self?.setupLocations(fromLocationList: list)    // callback to create annotations on mapView
            }
        }
    }
    
    // update tableView with new locations
    fileprivate func setupLocations(fromLocationList list: GoogleLocationList?) {
        guard let locs = list?.locations else { return }
        self.locations = locs
        foundLocations?(locs)
        tableView.reloadData()
    }
}

extension ResultsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ResultCell
        cell.model = locations[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let placeId = locations[indexPath.row].place_id else { return }
        selectedPlaceId?(placeId)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
