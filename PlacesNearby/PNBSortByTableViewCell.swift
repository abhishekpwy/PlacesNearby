//
//  PNBSortByTableViewCell.swift
//  PlacesNearby
//
//  Created by Abhishek on 22/11/16.
//  Copyright © 2016 Abhishek. All rights reserved.
//

import UIKit

class PNBSortByTableViewCell: UITableViewCell {

	@IBOutlet weak var backGroundViewForCell: UIView!
	@IBOutlet weak var sortByImage: UIImageView!
	@IBOutlet weak var ratingSelectedButton: UIButton!
	@IBOutlet weak var distanceSelectedButton: UIButton!
	@IBOutlet weak var ratingSelectedImage: UIImageView!
	@IBOutlet weak var diastanceSelectedImage: UIImageView!

	@IBOutlet weak var defaultSortingButton: UIButton!
	@IBOutlet weak var defaultSortingImageSelected: UIImageView!
	let initialSortingMethod = PNBUserDefaultManager().getValueObject(key: PNBUserDefaultManager.KeysForUserDefault.sortBy) as! Int


	override func awakeFromNib() {
        super.awakeFromNib()
		self.backGroundViewForCell.layer.backgroundColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 0.2).cgColor
		self.distanceSelectedButton.layer.borderWidth = 0.7
		self.distanceSelectedButton.layer.borderColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 0.5).cgColor
		self.ratingSelectedButton.layer.borderWidth = 0.7
		self.ratingSelectedButton.layer.borderColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 0.5).cgColor
		self.defaultSortingButton.layer.borderWidth = 0.7
		self.defaultSortingButton.layer.borderColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 0.5).cgColor

		diastanceSelectedImage.isHidden = true
		ratingSelectedImage.isHidden = true
		defaultSortingImageSelected.isHidden = true
		if initialSortingMethod == SortingMethod.distance.rawValue {
			diastanceSelectedImage.isHidden = false
			sortByImage.image = UIImage(named:"DistanceSorting")!
		}else if initialSortingMethod == SortingMethod.rating.rawValue{
			ratingSelectedImage.isHidden = false
			sortByImage.image = UIImage(named:"RatingSorting")!
		}else {
			defaultSortingImageSelected.isHidden = false
			sortByImage.image = UIImage(named:"Releavance")
		}
    }
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)

		// Configure the view for the selected state
	}

	final func getCurrentState() -> Int {
		if diastanceSelectedImage.isHidden == false {
			return SortingMethod.distance.rawValue
		}else if ratingSelectedImage.isHidden == false {
			return SortingMethod.rating.rawValue
		}
		return SortingMethod.releavence.rawValue

	}

	@IBAction func distanceSelected(_ sender: Any) {
		diastanceSelectedImage.isHidden = false
		ratingSelectedImage.isHidden = true
		defaultSortingImageSelected.isHidden = true
		sortByImage.image = UIImage(named:"DistanceSorting")!

	}
	@IBAction func ratingSelected(_ sender: Any) {
		diastanceSelectedImage.isHidden = true
		ratingSelectedImage.isHidden = false
		defaultSortingImageSelected.isHidden = true
		sortByImage.image = UIImage(named:"RatingSorting")!
	}

	@IBAction func didSelectedSortByRelavance(_ sender: Any) {
		diastanceSelectedImage.isHidden = true
		ratingSelectedImage.isHidden = true
		defaultSortingImageSelected.isHidden = false
		sortByImage.image = UIImage(named:"Releavance")
	}

    
}
