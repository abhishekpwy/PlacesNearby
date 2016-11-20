//
//  PNBPlaceDetailsReviewsTableViewCell.swift
//  PlacesNearby
//
//  Created by Abhishek on 20/11/16.
//  Copyright © 2016 Abhishek. All rights reserved.
//

import UIKit

class PNBPlaceDetailsReviewsTableViewCell: UITableViewCell {

	@IBOutlet weak var name: UILabel!
	@IBOutlet weak var rating: UILabel!
	@IBOutlet weak var review: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
