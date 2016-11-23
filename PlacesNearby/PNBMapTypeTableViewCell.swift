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
	@IBOutlet weak var standardMapSelected: UIImageView!
	@IBOutlet weak var sateliteMapSelected: UIImageView!
	@IBOutlet weak var terrainMapSelected: UIImageView!
	@IBOutlet weak var standardMapButton: UIButton!
	@IBOutlet weak var sateliteMapButton: UIButton!
	@IBOutlet weak var terrainMapButton: UIButton!

	let intialValue = PNBUserDefaultManager().getValueObject(key: PNBUserDefaultManager.KeysForUserDefault.mapType) as! Int

    override func awakeFromNib() {
        super.awakeFromNib()
		setUpUI()
		setUpInitialValues()
    }

	private func setUpUI(){
		self.backgroundViewForCell.layer.backgroundColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 0.2).cgColor
		self.backgroundViewForCell.layer.borderColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 0.5).cgColor
		self.standardMapButton.layer.borderWidth = 0.7
		self.sateliteMapButton.layer.borderWidth = 0.7
		self.terrainMapButton.layer.borderWidth = 0.7
		self.standardMapButton.layer.borderColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 0.5).cgColor
		self.sateliteMapButton.layer.borderColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 0.5).cgColor
		self.terrainMapButton.layer.borderColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 0.5).cgColor
	}

	private func setUpInitialValues(){
		sateliteMapSelected.isHidden = true
		terrainMapSelected.isHidden = true
		standardMapSelected.isHidden = true
		if intialValue == MapType.satelite.rawValue {
			sateliteMapSelected.isHidden = false
			mapTypeImage.image = UIImage(named:"Satelite")!
		}else if intialValue == MapType.standard.rawValue{
			standardMapSelected.isHidden = false
			mapTypeImage.image = UIImage(named:"StandardMap")!
		}else {
			terrainMapSelected.isHidden = false
			mapTypeImage.image = UIImage(named:"Terrain")!
		}
	}

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

	final func getValueForMapType() -> Int {
		if standardMapSelected.isHidden == false {
			return MapType.standard.rawValue
		}else if sateliteMapSelected.isHidden == false {
			return MapType.satelite.rawValue
		}
		return MapType.terrain.rawValue
	}

	@IBAction func didSelectedStandardMap(_ sender: Any) {
		sateliteMapSelected.isHidden = true
		terrainMapSelected.isHidden = true
		standardMapSelected.isHidden = false
		mapTypeImage.image = UIImage(named:"StandardMap")!
	}
	@IBAction func didSelectedSateLiteMap(_ sender: Any) {
		sateliteMapSelected.isHidden = false
		terrainMapSelected.isHidden = true
		standardMapSelected.isHidden = true
		mapTypeImage.image = UIImage(named:"Satelite")!
	}
	@IBAction func didSelectedTerrainMap(_ sender: Any) {
		sateliteMapSelected.isHidden = true
		terrainMapSelected.isHidden = false
		standardMapSelected.isHidden = true
		mapTypeImage.image = UIImage(named:"Terrain")!
	}
	
}
