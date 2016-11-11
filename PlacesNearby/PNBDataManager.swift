//
//  PNBDataManager.swift
//  PlacesNearby
//
//  Created by Abhishek on 07/11/16.
//  Copyright © 2016 Abhishek. All rights reserved.
//

import Foundation

enum PNBErrorCodes:Int{
	case locationNotAvailableError = 1
}

class PNBDataManager {
	static let sharedDataManager = PNBDataManager()
	let locationDataManager = PNBLocationManager()
	let apiManager = PNBApiManager()

	final func fetchListOfPlaces(placeType:PlaceType) {
		locationDataManager.getCurrentLocation {
			[weak self]
			(error, currentLocation)
			in
			guard let blockSelf = self
				else{
					return
			}
			let lat = currentLocation!.coordinate.latitude
			let lang = currentLocation!.coordinate.longitude
			let radius = (PNBUserDefaultManager().getValueObject(key: PNBUserDefaultManager.KeysForUserDefault.radiusOfSearch) as! Int) * 1000
			blockSelf.apiManager.getListOfPlacesNearby(placeType: placeType, lat: lat, lang: lang, radius: radius, completion: {
				[weak self]
				(result, error)
				in
				guard let blockSelf = self
					else{
						return
				}
				
			})

		}
	}
}
