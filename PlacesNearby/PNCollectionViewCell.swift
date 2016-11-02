//
//  PNCollectionViewCell.swift
//  PlacesNearby
//
//  Created by Abhishek on 02/11/16.
//  Copyright © 2016 Abhishek. All rights reserved.
//

import UIKit

class PNCollectionViewCell: UICollectionViewCell {
	
	@IBOutlet weak var placesImage: UIImageView!
	@IBOutlet weak var placesTitle: UILabel!
	@IBOutlet weak var placesSubtitle: UILabel!
	@IBOutlet weak var backViewInBackground: UIView!

	final func setBorderColorToSomething(){
		backViewInBackground.layer.borderWidth = 0.7
		backViewInBackground.layer.borderColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 0.16).cgColor
	}
	
}
