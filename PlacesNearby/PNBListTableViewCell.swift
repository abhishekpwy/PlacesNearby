//
//  PNBListTableViewCell.swift
//  PlacesNearby
//
//  Created by Abhishek on 12/11/16.
//  Copyright © 2016 Abhishek. All rights reserved.
//

import UIKit

class PNBListTableViewCell: UITableViewCell {
	@IBOutlet weak var nameOfPlace: UILabel!
	@IBOutlet weak var vicinityOfPlace: UILabel!
	@IBOutlet weak var ratingImageView: UIImageView!
	@IBOutlet weak var openNowImageView: UIImageView!
	@IBOutlet weak var distanceImageView: UIImageView!
	@IBOutlet weak var ratingLabel: UILabel!
	@IBOutlet weak var openNowLabel: UILabel!
	@IBOutlet weak var distanceLabel: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
