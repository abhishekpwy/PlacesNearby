//
//  PNBPlaceDetailsViewController.swift
//  PlacesNearby
//
//  Created by Abhishek on 19/11/16.
//  Copyright © 2016 Abhishek. All rights reserved.
//

import UIKit
import CoreLocation

class PNBPlaceDetails{
	let placeID:String
	let placeTitle:String
	let placeFormattedAddress:String
	let placeType:String
	let placePhoneNumber:String?
	let placeFomattedOpeningHours:String?
	let placeWebsiteUrl:String?
	let placeCost:Int?
	let placeLoaction:CLLocation
	let reviews:[PNBReviews]?
	let photoreferences:[String]?
	let isOpenNow:Bool?
	init (placeID:String, placeTitle:String, address:String, type:String, phNo:String?, openingHrs:String?, websiteURL:String?, cost:Int?, placeLoaction:CLLocation, reviews:[PNBReviews]?, photoreferences:[String]?, isOpenNow:Bool?){
		self.placeID = placeID
		self.placeTitle = placeTitle
		self.placeFormattedAddress = address
		self.placeType = type
		self.placePhoneNumber = phNo
		self.placeFomattedOpeningHours = openingHrs
		self.placeWebsiteUrl = websiteURL
		self.placeCost = cost
		self.placeLoaction = placeLoaction
		self.reviews = reviews
		self.photoreferences = photoreferences
		self.isOpenNow = isOpenNow
	}
}

class PNBReviews{
	let nameOfReviewer:String
	let rating:Double
	let ratingText:String
	init(name:String, rating:Double, ratingText:String){
		self.nameOfReviewer = name
		self.rating = rating
		self.ratingText = ratingText
	}
}

class PNBPlaceDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	@IBOutlet weak var containerView: UIView!
	@IBOutlet weak var tableView: UITableView!
	let placesPicDetailsID = "PNBDetailsImages"
	let placeDetailsTitleAndAddress = "placetitleandaddress"
	let blankCellID = "PNBDetailsTableViewCell"
	let openNowCellID = "PNBDetailsOpenStatusTableViewCell"
	let placeID:String
	var placeDetails:PNBPlaceDetails?
	init(placeID:String){
		self.placeID = placeID
		super.init(nibName: "PNBPlaceDetailsViewController", bundle: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		self.tableView.estimatedRowHeight = 90
		self.tableView.rowHeight = UITableViewAutomaticDimension
		self.automaticallyAdjustsScrollViewInsets = false
		tableView.register(UINib(nibName: "PNBDetailsImagesCellTableViewCell", bundle: nil), forCellReuseIdentifier: placesPicDetailsID)
		tableView.register(UINib(nibName: "PNBDetailsPageTitleCellTableViewCell", bundle: nil), forCellReuseIdentifier: placeDetailsTitleAndAddress)
		tableView.register(UINib(nibName: "PNBDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: blankCellID)
		tableView.register(UINib(nibName: "PNBDetailsOpenStatusTableViewCell", bundle: nil), forCellReuseIdentifier: openNowCellID)
		tryToGetPlaceDetails()
	}

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}

	@IBAction func didClickBackButton(_ sender: AnyObject) {
		self.navigationController?.popViewController(animated: true)
	}

	private func tryToGetPlaceDetails() {
		PNBDataManager.sharedDataManager.getPlaceDetailsFor(placeID: self.placeID) {
			[weak self]
			(placeDetails, error)
			in
			guard let blockSelf = self
				else {
					return
			}
			if error != nil {
				blockSelf.showError(error: error!)
				return
			}
			runInMainQueue {
				[weak self]
				in
				guard let blockSelf = self
					else{
						return
				}
				blockSelf.placeDetails = placeDetails!
				blockSelf.tableView.reloadData()
			}
		}
	}

	func showError(error:NSError){

	}

	var colorForOpenNow:UIColor {
		if self.placeDetails!.isOpenNow == nil {
			return UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1.0)
		}
		if self.placeDetails!.isOpenNow! {
			return UIColor(red: 65/255, green: 117/255, blue: 5/255, alpha: 1.0)
		}
		return UIColor(red: 208/255, green: 2/255, blue: 27/255, alpha: 1.0)
	}

	//MARK:Table data source
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if self.placeDetails == nil {
			return 0
		}
		return 3
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.row == 0 {
			let cell = tableView.dequeueReusableCell(withIdentifier: placesPicDetailsID, for: indexPath) as! PNBDetailsImagesCellTableViewCell
			cell.loadListOfPhotos(photoReferences: self.placeDetails!.photoreferences, parentController: self)
			return cell
		}
		if indexPath.row == 1{
			let cell = tableView.dequeueReusableCell(withIdentifier: placeDetailsTitleAndAddress, for: indexPath) as! PNBDetailsPageTitleCellTableViewCell
			cell.nameOfPlace.text = placeDetails!.placeTitle
			cell.formattedAddress.text = placeDetails!.placeFormattedAddress
			cell.types.text = placeDetails!.placeType
			return cell
		}

		if indexPath.row == 2 && (placeDetails!.isOpenNow != nil || placeDetails!.placePhoneNumber != nil || placeDetails!.placeWebsiteUrl != nil) {
			let cell = tableView.dequeueReusableCell(withIdentifier: openNowCellID, for: indexPath) as! PNBDetailsOpenStatusTableViewCell
			//open now
			cell.openStatueLabel.textColor = self.colorForOpenNow
			if placeDetails!.isOpenNow == nil{
				cell.openStatueLabel.text = "Current open Status is Unknown"
			}else if placeDetails!.isOpenNow!{
				cell.openStatueLabel.text = "Place is Open now"
			}else {
				cell.openStatueLabel.text = "Placed is closed currently"
			}

			//open time

			if placeDetails!.placeFomattedOpeningHours == nil {
				cell.openTimingLabel.text = "Opening and closing time are not shared"
			}else {
				cell.openTimingLabel.text = placeDetails!.placeFomattedOpeningHours!
			}

			//phone nu
			if placeDetails!.placePhoneNumber == nil {
				cell.pnNoLabel.text = "Phone Number not shared"
			}else {
				cell.pnNoLabel.text = placeDetails!.placePhoneNumber!
			}

			//website
			if placeDetails!.placeWebsiteUrl == nil {
				cell.websiteUrlButton.text = ""
			}else {
				cell.websiteUrlButton.text = placeDetails!.placeWebsiteUrl!
			}

			return cell
		}

		let blankCell = tableView.dequeueReusableCell(withIdentifier: blankCellID, for: indexPath) as! PNBDetailsTableViewCell
		return blankCell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

	}


}
