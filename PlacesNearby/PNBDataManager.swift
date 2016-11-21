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
	case placeDetailsCanNotBeloaded = 8
	case someThingWentWrong = 9
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

	final func fetchListOfPlacesFromTextSearch(searchText:String, completion:@escaping ((_ listOfPlaces:[PlaceDataForListAndMap]?, _ error:NSError?) -> Void)) {
		//check for netwrok connectivity first
		if !Reachability.isConnectedToNetwork(){
			let error = NSError(domain: PNBErrorDomain, code: PNBErrorCodes.InternetNotAvailable.rawValue, userInfo: nil)
			completion(nil, error)
			return
		}
		//this is fresh place request query so make next page token nil
		PNBUserDefaultManager().setValueForObject(value: nil, forKey: PNBUserDefaultManager.KeysForUserDefault.nextPageToken)
		//add search history
		addPlaceInTextSearchHistory(textSearch: searchText)

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
			blockSelf.apiManager.getListOfPlacesNearbyWithTextSearch(searchText: searchText, lat: lat, lang: lang, radius: radius, completion: {
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

	private func addPlaceInTextSearchHistory(textSearch:String){
		let userDefaultsManager = PNBUserDefaultManager()
		var array = userDefaultsManager.getValueObject(key: PNBUserDefaultManager.KeysForUserDefault.searchHisory) as! [String]
		if array.count < 4{
			if array.index(of: textSearch) == nil{
				array.append(textSearch)
			}
		}else {
			array.removeLast()
			array.insert(textSearch, at: 0)
		}
		userDefaultsManager.setValueForObject(value: array as AnyObject?, forKey: PNBUserDefaultManager.KeysForUserDefault.searchHisory)

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

			var vicinity:String = ""
			if let vicinityFromPlaceSearch = place["vicinity"] as? String{
				vicinity = vicinityFromPlaceSearch
			}else if let vicinityFromTextSearch = place["formatted_address"] as? String{
				vicinity = vicinityFromTextSearch
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

	private func getPlaceDetailsObjectFromJson(jsonDict:[String:Any]) -> PNBPlaceDetails? {
		guard let placesDetailsInJson = jsonDict["result"] as? [String:AnyObject]
			else{
				return nil
		}
		guard let fomattedAddress = placesDetailsInJson["formatted_address"] as? String
			else {
				return nil
		}
		guard let placeID = placesDetailsInJson["place_id"] as? String
			else {
				return nil
		}
		guard let placeTitle = placesDetailsInJson["name"] as? String
			else {
				return nil
		}

		guard let location = placesDetailsInJson["geometry"]?["location"] as? [String:AnyObject]
			else{
				return nil
		}

		guard let lat = location["lat"] as? Double
			else{
				return nil
		}

		guard let lng = location["lng"] as? Double
			else{
				return nil
		}

		let placeLocation = CLLocation(latitude: lat, longitude: lng)

		//mendtry results fetched, now get optional values

		let isPermanentlyClosed = placesDetailsInJson["permanently_closed"] as? Bool ?? false

		var formattedOpeningHourText:String? = nil
		var isOpenNow:Bool?

		if let openingHoursInfo = placesDetailsInJson["opening_hours"] as? [String:AnyObject] {
			formattedOpeningHourText = getFormattedOpeningHourText(info: openingHoursInfo)
			if let openStatus = openingHoursInfo["open_now"] as? Bool {
				isOpenNow = openStatus
			}
		}


		var website:String? = nil
		if let webSiteUrl = placesDetailsInJson["website"] as? String {
			website = webSiteUrl
		}

		var cost:Int? = nil
		if let costOfPlace = placesDetailsInJson["price_level"] as? Int{
			cost = costOfPlace
		}

		var photoReferences:[String]?
		if let photos = placesDetailsInJson["photos"] as? [[String:AnyObject]]{
			for photo in photos{
				if let photoReference = photo["photo_reference"] as? String{
					if photoReferences == nil {
						photoReferences = [String]()
					}
					photoReferences!.append(photoReference)
				}
			}
		}
		var reviews:[PNBReviews]?
		if let reviewsDict = placesDetailsInJson["reviews"] as? [[String:AnyObject]]{
			for review in reviewsDict {
				let name = review["author_name"] as! String
				let text = review["text"] as! String
				let rating = review["rating"] as! Double
				if reviews == nil {
					reviews = [PNBReviews]()
				}
				reviews!.append(PNBReviews(name: name, rating: rating, ratingText: text))
			}
		}

		var types = "("
		var arrayOfTypes = (placesDetailsInJson["types"] as! [String])
		//remove point of interest and extablstmet
		if let indexOfPtOfInterest = arrayOfTypes.index(of: "point_of_interest"){
			arrayOfTypes.remove(at: indexOfPtOfInterest)
		}

		if let indexOfPtOfEstablishment = arrayOfTypes.index(of: "establishment"){
			arrayOfTypes.remove(at: indexOfPtOfEstablishment)
		}

		for (index,type)in arrayOfTypes.enumerated()
		{
			var withoutUderscore = type.replacingOccurrences(of: "_", with: " ")
			if index != arrayOfTypes.count - 1 {
				withoutUderscore += ", "
			}else {
				withoutUderscore += ")"
			}

			types += withoutUderscore
		}

		var phoneNumber:String?
		if let phNo = placesDetailsInJson["international_phone_number"] as? String{
			phoneNumber = phNo
 		}

		var rating:Double?
		if let ratingValue = placesDetailsInJson["rating"] as? Double{
			rating = ratingValue
		}


		return PNBPlaceDetails(placeID: placeID, placeTitle: placeTitle, address: fomattedAddress, type: types, phNo: phoneNumber, openingHrs: formattedOpeningHourText, websiteURL: website, cost: cost, placeLoaction: placeLocation, reviews: reviews, photoreferences: photoReferences, isOpenNow:isOpenNow, rating:rating)

	}

	final func getFormattedOpeningHourText(info:[String:AnyObject]?) -> String? {
		var formattedOpeningHourText:String? = nil
		guard let openingHoursInfo = info
			else{
				return nil
		}

		let todayWeekIndex = getDayOfWeek()! - 1
		if let periods = openingHoursInfo["periods"] as? [[String:AnyObject]]{
			for periodItem in periods{
				guard let open = periodItem["open"] as? [String:AnyObject]
					else{
						continue
				}
				guard let day = open["day"] as? Int
					else{
						continue
				}
				let openTime = Int(open["time"] as! String)
				let openTimeString = getStringTimeFromTime(time: openTime!)

				guard let close = periodItem["close"] as? [String:AnyObject]
					else{
						if day == 0 && openTime == 0000{
							return "Open 24 Hours"
						}
					continue
				}

				if day == todayWeekIndex {
					let closeTime = Int(close["time"] as! String)
					let closeTimeString = getStringTimeFromTime(time: closeTime!)
					formattedOpeningHourText = "Today open from \(openTimeString) to \(closeTimeString)"
				}
			}
		}

		return formattedOpeningHourText
	}

	func getDayOfWeek()->Int? {
		let todayDate = NSDate()
		let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier(rawValue: NSGregorianCalendar))
		let myComponents = myCalendar?.components(.weekday, from: todayDate as Date)
		let weekDay = myComponents?.weekday
		return weekDay
 }

	private func getStringTimeFromTime(time:Int) -> String{
		let min = (time % 100)
		let hour = (time / 100)
		if hour == 0 && min == 0{
			return "Midnight"
		}

		let minText = min > 0 ?  "\(min)" : ""
		var hourText = "\(hour)"
		var amPMText = " AM"
		if hour > 12 {
			hourText = "\(hour - 12)"
			amPMText = " PM"
		}
		if minText.isEmpty {
			let string = "\(hourText)" + amPMText
			return string
		}
		let string = "\(hourText):\(minText)" + amPMText
		return string
	}


	final func getPlaceDetailsFor(placeID:String, completion: @escaping (_ placeDetails:PNBPlaceDetails?, _ error:NSError?) -> Void){
		//check for netwrok connectivity first
		if !Reachability.isConnectedToNetwork(){
			let error = NSError(domain: PNBErrorDomain, code: PNBErrorCodes.InternetNotAvailable.rawValue, userInfo: nil)
			completion(nil, error)
			return
		}
		apiManager.getPlaceDetails(forPlaceID: placeID) {
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
			if let details = blockSelf.getPlaceDetailsObjectFromJson(jsonDict: result!){
				completion(details, nil)
				return
			}

			let error = NSError(domain: PNBErrorDomain, code: PNBErrorCodes.placeDetailsCanNotBeloaded.rawValue, userInfo: nil)
			completion(nil, error)
		}
	}
}
