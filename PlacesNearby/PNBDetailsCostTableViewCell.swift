//
//  PNBDetailsCostTableViewCell.swift
//  PlacesNearby
//
//  Created by Abhishek on 20/11/16.
//  Copyright © 2016 Abhishek. All rights reserved.
//

import UIKit

class PNBDetailsCostTableViewCell: UITableViewCell {

	@IBOutlet weak var costImage: UIImageView!
	@IBOutlet weak var noOfVisitorsImage: UIImageView!
	@IBOutlet weak var costLabel: UILabel!
	@IBOutlet weak var numberOfVisitorsLabel: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
