//
//  PNBMapTypeTableViewCell.swift
//  PlacesNearby
//
//  Created by Abhishek on 23/11/16.
//  Copyright © 2016 Abhishek. All rights reserved.
//

import UIKit

class PNBMapTypeTableViewCell: UITableViewCell {

	@IBOutlet weak var backgroundViewForCell: UIView!
	@IBOutlet weak var mapTypeImage: UIImageView!
	@IBOutlet weak var standardSwitch: UISwitch!
	@IBOutlet weak var sateliteSwitch: UISwitch!
	@IBOutlet weak var terrainSwitch: UISwitch!
	let intialValue = PNBUserDefaultManager().getValueObject(key: PNBUserDefaultManager.KeysForUserDefault.mapType) as! Int

    override func awakeFromNib() {
        super.awakeFromNib()
		self.backgroundViewForCell.layer.backgroundColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 0.2).cgColor
		self.backgroundViewForCell.layer.borderWidth = 1.0
		self.backgroundViewForCell.layer.borderColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 0.5).cgColor
		standardSwitch.isOn = false
		sateliteSwitch.isOn = false
		terrainSwitch.isOn = false
		if intialValue == MapType.standard.rawValue{
			standardSwitch.isOn = true
		}else if intialValue == MapType.satelite.rawValue{
			
		}
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
