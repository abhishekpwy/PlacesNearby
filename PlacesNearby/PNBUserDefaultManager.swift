//
//  PNBUserDefaultManager.swift
//  PlacesNearby
//
//  Created by Abhishek on 07/11/16.
//  Copyright © 2016 Abhishek. All rights reserved.
//

import Foundation

class PNBUserDefaultManager{
	static let sharedUserDefault = PNBUserDefaultManager()

	enum KeysForUserDefault:String {
		case radiusOfSearch = "radiusOfSearch"
	}
	final func getValueObject(key:KeysForUserDefault) -> AnyObject?{
		if let value = UserDefaults.standard.value(forKey: key.rawValue) {
			return value as AnyObject?
		}
		//default values
		switch key{
		case .radiusOfSearch:
			return Int(10) as AnyObject?
		}

	}

	final func setValueForObject(value:AnyObject, forKey:KeysForUserDefault) {
		UserDefaults.standard.set(value, forKey: forKey.rawValue)
	}
}
