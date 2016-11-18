//
//  PNBLocationManager.swift
//  PlacesNearby
//
//  Created by Abhishek on 07/11/16.
//  Copyright © 2016 Abhishek. All rights reserved.
//

import Foundation
import CoreLocation

class PNBLocationManager:NSObject, CLLocationManagerDelegate {

	let locationHelper = CLLocationManager()
	var currentCompletion:((_ error:Error?, _ currentLocation:CLLocation?) -> Void)?
	var isLocationEnabled:Bool {
		if CLLocationManager.locationServicesEnabled() {
			switch(CLLocationManager.authorizationStatus()) {
			case .notDetermined, .restricted, .denied:
				return false
			case .authorizedAlways, .authorizedWhenInUse:
				return true
			}
		} else {
			return false
		}
	}

	final func getCurrentLocation(withCompletion:@escaping (_ error:Error?, _ currentLocation:CLLocation?) -> Void) {
		self.currentCompletion = withCompletion
		self.locationHelper.requestWhenInUseAuthorization()
		if !CLLocationManager.locationServicesEnabled() {
			let error = NSError(domain: PNBErrorDomain, code: PNBErrorCodes.locationServiceDisabled.rawValue, userInfo: nil)
			currentCompletion!(error, nil)
			return
		}
		if CLLocationManager.authorizationStatus() == .denied {
			let error = NSError(domain: PNBErrorDomain, code: PNBErrorCodes.locationServiceDisabled.rawValue, userInfo: nil)
			currentCompletion!(error, nil)
			return
		}

		//everything alright, user loves us and wants to share location:
		locationHelper.delegate = self
		locationHelper.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
		locationHelper.startUpdatingLocation()
	}


	//MARK: Location manager delegate
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		self.currentCompletion!(error, nil)
	}

	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		self.locationHelper.stopUpdatingLocation()
		self.locationHelper.delegate = nil
		Swift.print("Got location")
		self.currentCompletion!(nil, manager.location!)
	}

	
}
