//
//  PNBTextSearchHostoryCellTableViewCell.swift
//  PlacesNearby
//
//  Created by Abhishek on 22/11/16.
//  Copyright © 2016 Abhishek. All rights reserved.
//

import UIKit

class PNBTextSearchHostoryCellTableViewCell: UITableViewCell {

	@IBOutlet weak var searchLabel: UILabel!
	@IBOutlet weak var container: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
		self.container.layer.borderWidth = 1.0
		self.container.layer.borderColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 0.30).cgColor
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
