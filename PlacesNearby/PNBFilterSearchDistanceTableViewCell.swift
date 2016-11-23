//
//  PNBFilterSearchDistanceTableViewCell.swift
//  PlacesNearby
//
//  Created by Abhishek on 22/11/16.
//  Copyright © 2016 Abhishek. All rights reserved.
//

import UIKit

class PNBFilterSearchDistanceTableViewCell: UITableViewCell {

	@IBOutlet weak var slider: UISlider!
	@IBOutlet weak var backgroundViewForCell: UIView!
	@IBOutlet weak var currentDistanceLabel: UILabel!
	let intialValue:Int = PNBUserDefaultManager().getValueObject(key: PNBUserDefaultManager.KeysForUserDefault.radiusOfSearch) as! Int
    override func awakeFromNib() {
        super.awakeFromNib()
		slider.value = Float(intialValue)
		setDistanceLabelFromSlider()
        // Initialization code
		self.backgroundViewForCell.layer.backgroundColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 0.2).cgColor
		self.backgroundViewForCell.layer.borderWidth = 1.0
		self.backgroundViewForCell.layer.borderColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 0.5).cgColor
		
    }

	private func setDistanceLabelFromSlider(){
		let value = Int(slider.value)
		currentDistanceLabel.text = "Radius Of Search (\(value)KM)"
	}

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
    
	@IBAction func didChangeValueForSlider(_ sender: Any) {
		setDistanceLabelFromSlider()
	}
}
