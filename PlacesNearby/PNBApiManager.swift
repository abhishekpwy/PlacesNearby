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

	final func getListOfPlacesNearby(placeType:PlaceType, lat:Double, lang:Double, radius:Int, completion:@escaping (_ result: [String:Any]?, _ error:NSError?) -> Void)
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
			if let error = errorFromRequest {
				completion(nil, error as NSError)
				return
			}

			if (responseFromRequest as! HTTPURLResponse).statusCode != 200 {
				let errorStatusNon200 = NSError(domain: "PNBError", code: PNBErrorCodes.statusCodeNot200.rawValue, userInfo: nil)
				completion(nil, errorStatusNon200)
				return
			}
			let data = blockSelf.getJsonFromData(data: dataFromRequest!)
			completion(data, nil)
		}.resume()
		
	}

	final func getJsonFromData(data:Data) -> [String:Any]?{
		do{

			let json = try JSONSerialization.jsonObject(with: data as Data, options:.allowFragments) as! [String:Any]
			return json

		}catch {
			print("Error with Json: \(error)")
			return nil
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
		if placeType.typesForApi.contains("|"){
			stringForUrl += "&type=\(placeType.typesForApi)"
		}else {
			stringForUrl += "&types=\(placeType.typesForApi)"
		}
		//key
		stringForUrl += "&key="+appKey
		let urlToUse = NSURL(string: (stringForUrl as NSString).addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)!
		return urlToUse

	}
}
