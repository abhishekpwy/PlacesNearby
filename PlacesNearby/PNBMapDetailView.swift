//
//  PNBMapDetailView.swift
//  PlacesNearby
//
//  Created by Abhishek on 14/11/16.
//  Copyright © 2016 Abhishek. All rights reserved.
//

import UIKit

class PNBMapDetailView: UIView {

	@IBOutlet weak var ratingImage: UIImageView!
	@IBOutlet weak var isOpenNowLabel: UILabel!
	@IBOutlet weak var ratingLabel: UILabel!
	@IBOutlet weak var isOpenNowImage: UIImageView!
	var placeDetails:PlaceDataForListAndMap?
	weak var delegateToDetailsViewProtocol:DetailsViewProtocol?

	class func instanceFromNib() -> PNBMapDetailView {
		return UINib(nibName: "MapCalloutView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! PNBMapDetailView
	}

	final func setImageAndLablesForPlaceDetails(placeDetails:PlaceDataForListAndMap, withDelgate:DetailsViewProtocol){
		self.delegateToDetailsViewProtocol = withDelgate
		self.placeDetails = placeDetails
		let isOpenNowData = placeDetails.textColorAndImageForOpenNow()
		self.isOpenNowImage.image = isOpenNowData.image
		self.isOpenNowLabel.text = isOpenNowData.text
		self.isOpenNowLabel.textColor = isOpenNowData.color

		let ratingData = placeDetails.imageTextAndTextColorForRating()
		self.ratingImage.image = ratingData.image
		self.ratingLabel.textColor = ratingData.colorForText
		self.ratingLabel.text = ratingData.text
	}


	@IBAction func didSelectedDetailsView(_ sender: AnyObject) {
		delegateToDetailsViewProtocol?.didTapOnDetailsViewWithID(placeID: self.placeDetails!.placeID)

	}

}
