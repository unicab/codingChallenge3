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
    
    fileprivate var locations: [GoogleLocation] = []
    var showDetails: ((_ placeId: String) -> Void)?
    var foundLocations: (([GoogleLocation]) -> Void)?
    var showMap: (() -> Void)?
    var toggleResultView: ((_ expand: Bool) -> Void)?
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        self.search(key: "starbucks") { [weak self] in
            guard let sself = self else { return }
            sself.foundLocations?(sself.locations)
        }
    }
    
    @IBAction func toggleButtonTapped(_ sender: Any?) {
        let expand = toggleButton.imageView?.image == #imageLiteral(resourceName: "upIcon")
        let image = expand ? #imageLiteral(resourceName: "closeIcon3") : #imageLiteral(resourceName: "upIcon")
        toggleButton.setImage(image, for: UIControlState())
        toggleResultView?(expand)
    }
    
    init() {
        super.init(nibName: "ResultsView", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "ResultCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        do {
            let locationList = try CoreDataStorage.fetchData()
            setupLocations(fromLocationList: locationList)
        } catch {
            
        }
    }
}

extension ResultsViewController {
    
    fileprivate func search(key: String, completion: @escaping () -> Void) {
        guard let curLocation = LocationManager.currentLocation else { return }
        
        GooglePlaces.shared.search(location: curLocation, radius: 500, query: key) { [weak self] list, error in
            guard let list = list else { return }
            
            dispatchMainAsync {
                try? CoreDataStorage.deleteData()
                try? CoreDataStorage.save(locationList: list)
                self?.setupLocations(fromLocationList: list)
                completion()
            }
        }

    }
    
    fileprivate func setupLocations(fromLocationList list: GoogleLocationList?) {
        guard let locs = list?.locations else { return }
        self.locations = locs
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
        showDetails?(placeId)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
