//
//  ResultCell.swift
//  googlePlaceSearch
//
//  Created by remotetiger on 3/12/17.
//  Copyright © 2017 TamNguyen. All rights reserved.
//

import Foundation
import UIKit

class ResultCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    
    // set view elements
    var model: GoogleLocation? {
        didSet {
            mainLabel.text = model?.name
            subLabel.text = model?.vacinity
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
