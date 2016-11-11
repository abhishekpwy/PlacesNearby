//
//  PNBApiManager.swift
//  PlacesNearby
//
//  Created by Abhishek on 07/11/16.
//  Copyright © 2016 Abhishek. All rights reserved.
//

import Foundation

class PNBApiManager{

	let placesApiURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
	let appKey = "AIzaSyDbMghJ-L1LjL9cYUvY72cdYKgyk2rGBTc"

	final func getListOfPlacesNearby(placeType:PlaceType, lat:Double, lang:Double, radius:Int, completion:(_ result:NSDictionary?, _ error:NSError?) -> Void)
	{
		let session = URLSession.shared
		let url = getUrlFor(placeType: placeType, lat: lat, lang: lang, radius: radius)
		session.dataTask(with: url as URL) {
			[weak self]
			(dataFromRequest, responseFromRequest, errorFromRequest)
			in
			//
			guard let blockSelf = self
				else{
					return
			}
			Swift.print(responseFromRequest)
			Swift.print(errorFromRequest)
			blockSelf.getJsonFromData(data: dataFromRequest!)
		}.resume()
		
	}

	final func getJsonFromData(data:Data){
		do{

			let json = try JSONSerialization.jsonObject(with: data as Data, options:.allowFragments) as! [String:Any]

//			if let stations = json["stations"] as? [[String: AnyObject]] {
//
//				for station in stations {
//
//					if let name = station["stationName"] as? String {
//
//						if let year = station["buildYear"] as? String {
//							print(name,year)
//						}
//
//					}
//				}
//
//			}
			Swift.print(json)

		}catch {
			print("Error with Json: \(error)")
		}

	}

	private func getUrlFor(placeType:PlaceType, lat:Double, lang:Double, radius:Int) -> NSURL
	{
		// example - https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=-33.8670522,151.1957362&radius=500&type=restaurant&keyword=cruise&key=YOUR_API_KEY
		var stringForUrl = placesApiURL
		//location
		stringForUrl += "location=\(lat),\(lang)"
		//radius
		stringForUrl += "&radius=\(radius)"
		//types
		stringForUrl += "&types=restaurant"
		//key
		stringForUrl += "&key="+appKey
		let urlToUse = NSURL(string: (stringForUrl as NSString).addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)!
		return urlToUse

	}
}
