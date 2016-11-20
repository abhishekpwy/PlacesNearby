//
//  PNBReviewsTopTableViewCell.swift
//  PlacesNearby
//
//  Created by Abhishek on 20/11/16.
//  Copyright © 2016 Abhishek. All rights reserved.
//

import UIKit

class PNBReviewsTopTableViewCell: UITableViewCell {

	@IBOutlet weak var starImage: UIImageView!
	@IBOutlet weak var numberOfVisitorsLabel: UILabel!
	@IBOutlet weak var ratingLabel: UILabel!
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
