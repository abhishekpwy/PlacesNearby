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
	let loadMoreApiURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
	let placeDetailsApi = "https://maps.googleapis.com/maps/api/place/details/json?"
	let textSearchApi = "https://maps.googleapis.com/maps/api/place/textsearch/json?"
	static let appKey = "AIzaSyDbMghJ-L1LjL9cYUvY72cdYKgyk2rGBTc"


	private func fireApiGetResponse(urlForApi:URL, completion:@escaping (_ result: [String:Any]?, _ error:NSError?) -> Void){
		let session = URLSession.shared
		session.dataTask(with: urlForApi){
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
				let errorStatusNon200 = NSError(domain: PNBErrorDomain, code: PNBErrorCodes.statusCodeNot200.rawValue, userInfo: nil)
				completion(nil, errorStatusNon200)
				return
			}
			let data = blockSelf.getJsonFromData(data: dataFromRequest!)
			completion(data, nil)
			return

			}.resume()
	}

	final func getListOfPlacesNearby(placeType:PlaceType, lat:Double, lang:Double, radius:Int, completion:@escaping (_ result: [String:Any]?, _ error:NSError?) -> Void)
	{
		let url = getUrlFor(placeType: placeType, lat: lat, lang: lang, radius: radius)
		fireApiGetResponse(urlForApi: url as URL, completion: completion)
	}

	final func getListOfPlacesNearbyWithTextSearch(searchText:String, lat:Double, lang:Double, radius:Int, completion:@escaping (_ result: [String:Any]?, _ error:NSError?) -> Void)
	{
		let url = getURLForTextSearch(searchString: searchText, lat: lat, lang: lang, radius: radius)
		fireApiGetResponse(urlForApi: url as URL, completion: completion)
	}

	final func loadMorePlacesNearBy(nextPageToken:String,completion:@escaping (_ result: [String:Any]?, _ error:NSError?) -> Void){
		let url = getUrlForLoadMore(pageToken: nextPageToken)
		fireApiGetResponse(urlForApi: url as URL, completion: completion)
	}

	final func getPlaceDetails(forPlaceID:String, completion:@escaping (_ result: [String:Any]?, _ error:NSError?) -> Void) {
		let url = getUrlForPlaceDetails(placeID: forPlaceID)
		fireApiGetResponse(urlForApi: url as URL, completion: completion)
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
			stringForUrl += "&types=\(placeType.typesForApi)"
		}else {
			stringForUrl += "&type=\(placeType.typesForApi)"
		}
		//key
		stringForUrl += "&key="+PNBApiManager.appKey
		let urlToUse = NSURL(string: (stringForUrl as NSString).addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)!
		return urlToUse

	}

	private func getUrlForLoadMore(pageToken:String) -> NSURL {
		//example https://maps.googleapis.com/maps/api/place/nearbysearch/json?pagetoken=CpQCAgEAAFxg8o-eU7_uKn7Yqjana-HQIx1hr5BrT4zBaEko29ANsXtp9mrqN0yrKWhf-y2PUpHRLQb1GT-mtxNcXou8TwkXhi1Jbk-ReY7oulyuvKSQrw1lgJElggGlo0d6indiH1U-tDwquw4tU_UXoQ_sj8OBo8XBUuWjuuFShqmLMP-0W59Vr6CaXdLrF8M3wFR4dUUhSf5UC4QCLaOMVP92lyh0OdtF_m_9Dt7lz-Wniod9zDrHeDsz_by570K3jL1VuDKTl_U1cJ0mzz_zDHGfOUf7VU1kVIs1WnM9SGvnm8YZURLTtMLMWx8-doGUE56Af_VfKjGDYW361OOIj9GmkyCFtaoCmTMIr5kgyeUSnB-IEhDlzujVrV6O9Mt7N4DagR6RGhT3g1viYLS4kO5YindU6dm3GIof1Q&key=YOUR_API_KEY
		var stringForUrl = loadMoreApiURL
		//pageToken
		stringForUrl += "pagetoken=" + pageToken
		//key
		stringForUrl += "&key="+PNBApiManager.appKey
		let urlToUse = NSURL(string: (stringForUrl as NSString).addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)!
		return urlToUse
	}

	static func getUrlForPhtotoDowload(photoReference:String, maxHeight:Int, maxWidth:Int) -> NSURL{
		//https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=CnRtAAAATLZNl354RwP_9UKbQ_5Psy40texXePv4oAlgP4qNEkdIrkyse7rPXYGd9D_Uj1rVsQdWT4oRz4QrYAJNpFX7rzqqMlZw2h2E2y5IKMUZ7ouD_SlcHxYq1yL4KbKUv3qtWgTK0A6QbGh87GB3sscrHRIQiG2RrmU_jF4tENr9wGS_YxoUSSDrYjWmrNfeEHSGSc3FyhNLlBU&key=YOUR_API_KEY
		var stringForUrl = "https://maps.googleapis.com/maps/api/place/photo?"
		//photoreference
		stringForUrl += "photoreference=" + photoReference

		stringForUrl += "&maxheight=\(maxHeight)"

		stringForUrl += "&maxwidth=\(maxWidth)"
		//key
		stringForUrl += "&key="+appKey
		let urlToUse = NSURL(string: (stringForUrl as NSString).addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)!
		return urlToUse

	}

	private func getUrlForPlaceDetails(placeID:String) -> NSURL {
		//https://maps.googleapis.com/maps/api/place/details/json?placeid=ChIJN1t_tDeuEmsRUsoyG83frY4&key=YOUR_API_KEY
		var stringForUrl = placeDetailsApi
		//pageToken
		stringForUrl += "placeid=" + placeID
		//key
		stringForUrl += "&key="+PNBApiManager.appKey
		let urlToUse = NSURL(string: (stringForUrl as NSString).addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)!
		return urlToUse
	}

	private func getURLForTextSearch(searchString:String, lat:Double, lang:Double, radius:Int) -> NSURL{
		//https://maps.googleapis.com/maps/api/place/textsearch/xml?query=restaurants+in+Sydney&key=YOUR_API_KEY
		var stringForUrl = textSearchApi
		//query String
		let queryString = searchString.replacingOccurrences(of: " ", with: "+")
		 stringForUrl += "query=" + queryString

		//location
		stringForUrl += "&location=\(lat),\(lang)"
		//radius
		stringForUrl += "&radius=\(radius)"

		//key
		stringForUrl += "&key="+PNBApiManager.appKey
		let urlToUse = NSURL(string: (stringForUrl as NSString).addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)!
		return urlToUse
	}
}
