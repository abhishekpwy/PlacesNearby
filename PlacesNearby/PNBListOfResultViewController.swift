//
//  PNBListOfResultViewController.swift
//  PlacesNearby
//
//  Created by Abhishek on 11/11/16.
//  Copyright © 2016 Abhishek. All rights reserved.
//

import UIKit
import CoreLocation

class PlaceDataForListAndMap {
	let placeID:String
	let nameOfPlace:String
	let addressOfPlace:String
	let isOpenNow:Bool?
	let currentLocation:CLLocation
	let distanceFromCurrentLocation:Double
	let rating:Double
	init(placeID:String, nameOfPlace:String, addressOfPlace:String, isOpenNow:Bool?, location: CLLocation, distanceFromCurrentLocation:Double,  rating:Double){
		self.placeID = placeID
		self.nameOfPlace = nameOfPlace
		self.addressOfPlace = addressOfPlace
		self.isOpenNow = isOpenNow
		self.distanceFromCurrentLocation = distanceFromCurrentLocation
		self.rating = rating
		self.currentLocation = location
	}
}

class PNBListOfResultViewController: UIViewController {
	let currentPlaceType:PlaceType

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
		tryToFetchListOfPlacesNearBy()
    }

	init(placesType:PlaceType){
		self.currentPlaceType = placesType
		super.init(nibName: "PNBListOfResultViewController", bundle: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func tryToFetchListOfPlacesNearBy(){
		PNBDataManager.sharedDataManager.fetchListOfPlaces(placeType: self.currentPlaceType) { (listOfPlaces, error) in
			//
		}
	}


}
