//
//  PNBListOfResultViewController.swift
//  PlacesNearby
//
//  Created by Abhishek on 11/11/16.
//  Copyright © 2016 Abhishek. All rights reserved.
//

import UIKit

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
		PNBDataManager.sharedDataManager.fetchListOfPlaces(placeType: self.currentPlaceType)
	}


}