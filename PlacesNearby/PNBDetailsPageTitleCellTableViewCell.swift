//
//  PNBDetailsPageTitleCellTableViewCell.swift
//  PlacesNearby
//
//  Created by Abhishek on 20/11/16.
//  Copyright © 2016 Abhishek. All rights reserved.
//

import UIKit

class PNBDetailsPageTitleCellTableViewCell: UITableViewCell {

	@IBOutlet weak var nameOfPlace: UILabel!
	@IBOutlet weak var types: UILabel!
	@IBOutlet weak var formattedAddress: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
