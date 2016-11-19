//
//  PNBPlaceDetailsViewController.swift
//  PlacesNearby
//
//  Created by Abhishek on 19/11/16.
//  Copyright © 2016 Abhishek. All rights reserved.
//

import UIKit
import CoreLocation

class PNBPlaceDetails{
	let placeID:String
	let placeTitle:String
	let placeFormattedAddress:String
	let placeType:String
	let placePhoneNumber:String?
	let placeFomattedOpeningHours:String?
	let placeWebsiteUrl:String?
	let placeCost:Int?
	let placeLoaction:CLLocation
	let reviews:[PNBReviews]?
	let photoreferences:[String]?
	init (placeID:String, placeTitle:String, address:String, type:String, phNo:String?, openingHrs:String?, websiteURL:String?, cost:Int?, placeLoaction:CLLocation, reviews:[PNBReviews]?, photoreferences:[String]?){
		self.placeID = placeID
		self.placeTitle = placeTitle
		self.placeFormattedAddress = address
		self.placeType = type
		self.placePhoneNumber = phNo
		self.placeFomattedOpeningHours = openingHrs
		self.placeWebsiteUrl = websiteURL
		self.placeCost = cost
		self.placeLoaction = placeLoaction
		self.reviews = reviews
		self.photoreferences = photoreferences
	}
}

class PNBReviews{
	let nameOfReviewer:String
	let rating:Double
	let ratingText:String
	init(name:String, rating:Double, ratingText:String){
		self.nameOfReviewer = name
		self.rating = rating
		self.ratingText = ratingText
	}
}

class PNBPlaceDetailsViewController: UIViewController {

	let placeID:String
	init(placeID:String){
		self.placeID = placeID
		super.init(nibName: "PNBPlaceDetailsViewController", bundle: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		tryToGetPlaceDetails()
	}

	private func tryToGetPlaceDetails() {
		PNBDataManager.sharedDataManager.getPlaceDetailsFor(placeID: self.placeID) {
			[weak self]
			(placeDetails, error)
			in
			guard let blockSelf = self
				else {
					return
			}
			

		}
	}

	

}
