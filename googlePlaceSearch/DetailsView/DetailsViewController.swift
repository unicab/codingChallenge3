//
//  DetailsViewController.swift
//  googlePlaceSearch
//
//  Created by remotetiger on 3/13/17.
//  Copyright © 2017 TamNguyen. All rights reserved.
//

import Foundation
import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var openingHoursLabel: UILabel!
    
    @IBAction func backToResultsView(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    init() {
        super.init(nibName: "DetailsView", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // setup view elements
    func setDetails(_ details: GoogleLocationDetails) {
        self.nameLabel.text = details.name
        self.phoneLabel.text = details.phoneNumber
        
        if let strAddress = details.streetAddress, let cityNZip = details.cityAndZip {
            self.addressLabel.text = "\(strAddress) \n\(cityNZip)"
        }
    }
}
