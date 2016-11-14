//
//  PNBAnnotation.swift
//  PlacesNearby
//
//  Created by Abhishek on 14/11/16.
//  Copyright © 2016 Abhishek. All rights reserved.
//

import UIKit
import MapKit

class PNBAnnotation: NSObject, MKAnnotation {
	public var coordinate: CLLocationCoordinate2D
	public var title: String?
	public var subtitle: String?
	public let placeDetails:PlaceDataForListAndMap
	init(placeDetails:PlaceDataForListAndMap) {
		self.coordinate = placeDetails.location.coordinate
		self.title = placeDetails.nameOfPlace
		self.placeDetails = placeDetails
		self.subtitle = placeDetails.addressOfPlace

	}
}
