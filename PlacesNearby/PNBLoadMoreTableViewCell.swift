//
//  PNBLoadMoreTableViewCell.swift
//  PlacesNearby
//
//  Created by Abhishek on 13/11/16.
//  Copyright © 2016 Abhishek. All rights reserved.
//

import UIKit

class PNBLoadMoreTableViewCell: UITableViewCell {

	@IBOutlet weak var loadMoreContent: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		self.loadMoreContent.layer.borderWidth = 1.0
		self.loadMoreContent.layer.borderColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 0.2).cgColor
		self.loadMoreContent.layer.cornerRadius = 13
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
