//
//  PNBDataManager.swift
//  PlacesNearby
//
//  Created by Abhishek on 07/11/16.
//  Copyright © 2016 Abhishek. All rights reserved.
//

import Foundation
import CoreLocation


enum PNBErrorCodes:Int{
	case locationNotAvailableError = 1
	case statusCodeNot200 = 2
	case listOfPlacesFromApiEmpty = 3
	case InternetNotAvailable = 4
	case locationServiceDisabled = 5
	case loadMoreWithoudNextPageToken = 6
	case loadMoreReturnedZeroPlaces = 7
}

//somes constants
let PNBErrorDomain = "PNBError"

class PNBDataManager {
	//singelton
	static let sharedDataManager = PNBDataManager()
	let locationDataManager = PNBLocationManager()
	let apiManager = PNBApiManager()

	

	final func fetchListOfPlaces(placeType:PlaceType, completion:@escaping ((_ listOfPlaces:[PlaceDataForListAndMap]?, _ error:NSError?) -> Void))
	{
		//check for netwrok connectivity first
		if !Reachability.isConnectedToNetwork(){
			let error = NSError(domain: PNBErrorDomain, code: PNBErrorCodes.InternetNotAvailable.rawValue, userInfo: nil)
			completion(nil, error)
			return
		}
		//this is fresh place request query so make next page token nil
		PNBUserDefaultManager().setValueForObject(value: nil, forKey: PNBUserDefaultManager.KeysForUserDefault.nextPageToken)

		locationDataManager.getCurrentLocation {
			[weak self]
			(error, currentLocation)
			in
			guard let blockSelf = self
				else{
					return
			}
			if error != nil {
				completion(nil, error! as NSError)
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
				if error != nil{
					completion(nil, error! as NSError)
					return
				}
				if let listOfPlacesFromApi = blockSelf.getListOfPlaceDataFromJson(currentLocation: currentLocation!, jsonDict: result!){
					if listOfPlacesFromApi.count > 0{
						completion(listOfPlacesFromApi, nil)
						return
					}
				}
				let error = NSError(domain: PNBErrorDomain, code: PNBErrorCodes.listOfPlacesFromApiEmpty.rawValue, userInfo: nil)
				completion(nil, error)
			})

		}
	}

	private func getListOfPlaceDataFromJson(currentLocation:CLLocation, jsonDict:[String:Any]) -> [PlaceDataForListAndMap]?{
		var arrayOfPlaces = [PlaceDataForListAndMap]()
		guard let arrayOfPlacesDetailsInJson = jsonDict["results"] as? [[String:AnyObject]]
			else{
				return nil
		}
		if let nextPageToken = jsonDict["next_page_token"] as? String{
			PNBUserDefaultManager().setValueForObject(value: nextPageToken as AnyObject?, forKey: PNBUserDefaultManager.KeysForUserDefault.nextPageToken)
		}else {
			PNBUserDefaultManager().setValueForObject(value: nil, forKey: PNBUserDefaultManager.KeysForUserDefault.nextPageToken)
		}
		for place in arrayOfPlacesDetailsInJson {
			//get location
			guard let location = place["geometry"]?["location"] as? [String:AnyObject]
				else{
					continue
			}

			guard let latitude = location["lat"] as? Double
				else{
					continue
			}

			guard let longitude = location["lng"] as? Double
				else{
					continue
			}

			guard let placeID = place["place_id"] as? String
				else {
					continue
			}

			guard let rating = place["rating"] as? Double
				else{
					continue
			}

			guard let name = place["name"] as? String
				else{
					continue
			}

			guard let vicinity = place["vicinity"] as? String
				else{
					continue
			}

			var isOpenNow:Bool?
			if let opneNow = place["opening_hours"]?["open_now"] as? NSNumber{
				isOpenNow = opneNow.boolValue
			}

			let latLang = CLLocation(latitude: latitude, longitude: longitude)
			let kmDistance = currentLocation.distance(from: latLang)/1000

			let placeFromJsonData = PlaceDataForListAndMap(placeID: placeID, nameOfPlace: name, addressOfPlace: vicinity, isOpenNow: isOpenNow, location: latLang, distanceFromCurrentLocation: kmDistance, rating: rating)
			arrayOfPlaces.append(placeFromJsonData)
		}
		return arrayOfPlaces
	}

	final func loadMorePlaces(completion:@escaping ((_ listOfPlaces:[PlaceDataForListAndMap]?, _ error:NSError?) -> Void)){
		//check for netwrok connectivity first
		if !Reachability.isConnectedToNetwork(){
			let error = NSError(domain: PNBErrorDomain, code: PNBErrorCodes.InternetNotAvailable.rawValue, userInfo: nil)
			completion(nil, error)
			return
		}
		guard let nextPageToken = PNBUserDefaultManager().getValueObject(key: PNBUserDefaultManager.KeysForUserDefault.nextPageToken) as? String
			else{
				let error = NSError(domain: PNBErrorDomain, code: PNBErrorCodes.loadMoreWithoudNextPageToken.rawValue, userInfo: nil)
				completion(nil, error)
				return
		}
		locationDataManager.getCurrentLocation {
			[weak self]
			(error, currentLocation)
			in
			guard let blockSelf = self
				else{
					return
			}
			if error != nil {
				completion(nil, error! as NSError)
				return
			}
			blockSelf.apiManager.loadMorePlacesNearBy(nextPageToken: nextPageToken) {
				[weak self]
				(result, error)
				in
				guard let blockSelf = self
					else{
						return
				}
				if error != nil{
					completion(nil, error! as NSError)
					return
				}
				if let listOfPlacesFromApi = blockSelf.getListOfPlaceDataFromJson(currentLocation: currentLocation!, jsonDict: result!){
					if listOfPlacesFromApi.count > 0{
						completion(listOfPlacesFromApi, nil)
						return
					}
				}
				let error = NSError(domain: PNBErrorDomain, code: PNBErrorCodes.loadMoreReturnedZeroPlaces.rawValue, userInfo: nil)
				completion(nil, error)
			}
		}


	}
}
