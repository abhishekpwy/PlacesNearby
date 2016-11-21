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
	let rating:Double?
	init (placeID:String, placeTitle:String, address:String, type:String, phNo:String?, openingHrs:String?, websiteURL:String?, cost:Int?, placeLoaction:CLLocation, reviews:[PNBReviews]?, photoreferences:[String]?, isOpenNow:Bool?, rating:Double?){
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
		self.rating = rating
	}

	var shouldShowCostRow:Bool {
		if self.placeCost != nil || self.reviews != nil {
			return true
		}

		return false
	}

	var shouldShowOpenNowRow:Bool {
		if self.isOpenNow != nil || self.placePhoneNumber != nil || self.placeWebsiteUrl != nil {
			return true
		}
		return false
	}

	var shouldShowReviewsRow:Bool {
		if self.reviews != nil && self.reviews!.count > 0 {
			return true
		}
		return false
	}

	var numberOfRowNeeded:Int {
		var numberOfRows = 2
		if shouldShowCostRow {
			numberOfRows += 1
		}
		if shouldShowOpenNowRow{
			numberOfRows += 1
		}
		if shouldShowReviewsRow {
			numberOfRows += self.reviews!.count
		}
		if self.rating != nil {
			numberOfRows += 1
		}
		return numberOfRows
	}

	final func costImageTextAndColor() -> (cost:String, color:UIColor, image:UIImage){
		var cost:String = "Cost- Unknown"
		var image:UIImage = UIImage(named: "NotInfoCost")!
		var color:UIColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1.0)
		if let costOfPlace = self.placeCost		{
			if costOfPlace == 0 {
				cost  = "Free of cost"
				image = UIImage(named: "CostLow")!
				color = UIColor(red: 65/255, green: 117/255, blue: 5/255, alpha: 1.0)
			}else if costOfPlace == 1 {
				cost = "Low cost"
				image = UIImage(named: "CostLow")!
				color = UIColor(red: 65/255, green: 117/255, blue: 5/255, alpha: 1.0)
			}else if costOfPlace == 2{
				cost = "Moderate cost"
				image = UIImage(named: "CostMed")!
				color = UIColor(red: 245/255, green: 166/255, blue: 35/255, alpha: 1.0)
			}else if costOfPlace == 3{
				cost = "Expensive place"
				image = UIImage(named: "CostExpensive")!
				color = UIColor(red: 197/255, green: 105/255, blue: 116/255, alpha: 1.0)
			}else if costOfPlace == 4{
				cost = "Very Expensive place"
				image = UIImage(named: "CostVeyExpensive")!
				color = UIColor(red: 174/255, green: 2/255, blue: 23/255, alpha: 1.0)
			}
		}
		return (cost, color, image)
	}

	final func numberOfVisitorsDetails() -> (text:String, color:UIColor, image:UIImage){
		var text = "Number of visitors Unkonwn"
		var color = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1.0)
		var image = UIImage(named: "Unknown")!
		if let ratings = self.reviews{
			if ratings.count == 0 {
				text = "Low number of visitors"
				color = UIColor(red: 174/255, green: 2/255, blue: 23/255, alpha: 1.0)
				image = UIImage (named:"LowVisitors")!
			}else if ratings.count < 5{
				text = "Moderate number of visitors"
				color = UIColor(red: 245/255, green: 166/255, blue: 35/255, alpha: 1.0)
				image = UIImage (named:"ModerateVisitors")!
			}else {
				text = "High number of visitors"
				color = UIColor(red: 65/255, green: 117/255, blue: 5/255, alpha: 1.0)
				image = UIImage (named:"HighVisitors")!
			}
		}
		return (text, color, image)
	}

	final func ratingImageTextAndTextColor() -> (ratingText:String, color:UIColor, image:UIImage, visitorsText:String){
		var ratingText = "Unknown rating"
		var color = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1.0)
		var image = UIImage(named: "UnknownRating")
		var visitorsText = ""
		if self.reviews != nil {
			visitorsText = "- \(self.reviews!.count) Reviews"
		}
		if let ratingValue = self.rating {
			ratingText = "\(self.rating!) Stars"
			if ratingValue < 2 {
				color = UIColor(red: 174/255, green: 2/255, blue: 23/255, alpha: 1.0)
				image = UIImage(named:"LowRating")
			}else if ratingValue <= 3 {
				color = UIColor(red: 245/255, green: 166/255, blue: 35/255, alpha: 1.0)
				image = UIImage(named:"MediumRating")
			}else if ratingValue <= 4 {
				color = UIColor(red: 139/255, green: 226/255, blue: 51/255, alpha: 1.0)
				image = UIImage(named:"ModerateRating")
			}else {
				color = UIColor(red: 65/255, green: 117/255, blue: 5/255, alpha: 1.0)
				image = UIImage(named:"HighRating")
			}
		}
		return (ratingText, color, image!, visitorsText)
	}

	final func ratingTextAndColor(forIndex:Int) -> (rating:String, name:String, color:UIColor, text:String){
		var name = "(No Name)"
		var rating = "Unknown"
		var color = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1.0)
		var ratignText = ""
		if let reviewsList = self.reviews{
			let reviewIndex = forIndex - (self.numberOfRowNeeded - reviewsList.count)
			if reviewIndex >= 0 && reviewIndex < reviewsList.count{
				let review = reviewsList[reviewIndex]
				name = review.nameOfReviewer
				rating = "\(review.rating) Stars"
				ratignText = review.ratingText
				color = review.colorForRating
			}
		}
		return (rating, name, color, ratignText)
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

	var colorForRating:UIColor{
		if rating < 2 {
			return UIColor(red: 174/255, green: 2/255, blue: 23/255, alpha: 1.0)
		}else if rating <= 3 {
			return UIColor(red: 245/255, green: 166/255, blue: 35/255, alpha: 1.0)
		}else if rating <= 4 {
			return UIColor(red: 139/255, green: 226/255, blue: 51/255, alpha: 1.0)
		}else {
			return UIColor(red: 65/255, green: 117/255, blue: 5/255, alpha: 1.0)
		}
	}
}

class PNBPlaceDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ErrorControllerDelagte {

	@IBOutlet weak var tableContainerView: UIView!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	@IBOutlet weak var containerView: UIView!
	@IBOutlet weak var tableView: UITableView!
	var errorView:UIView?
	let placesPicDetailsID = "PNBDetailsImages"
	let placeDetailsTitleAndAddress = "placetitleandaddress"
	let blankCellID = "PNBDetailsTableViewCell"
	let openNowCellID = "PNBDetailsOpenStatusTableViewCell"
	let costCellID = "PNBDetailsCostTableViewCell"
	let topRowReviewID = "PNBReviewsTopTableViewCell"
	let reviewCellID = "PNBPlaceDetailsReviewsTableViewCell"
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
		tableView.register(UINib(nibName: "PNBDetailsCostTableViewCell", bundle: nil), forCellReuseIdentifier: costCellID)
		tableView.register(UINib(nibName: "PNBReviewsTopTableViewCell", bundle: nil), forCellReuseIdentifier: topRowReviewID)
		tableView.register(UINib(nibName: "PNBPlaceDetailsReviewsTableViewCell", bundle: nil), forCellReuseIdentifier: reviewCellID)
		tryToGetPlaceDetails()
	}

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}

	@IBAction func didClickBackButton(_ sender: AnyObject) {
		self.navigationController?.popViewController(animated: true)
	}

	private func tryToGetPlaceDetails() {
		self.activityIndicator.isHidden = false
		self.activityIndicator.startAnimating()
		PNBDataManager.sharedDataManager.getPlaceDetailsFor(placeID: self.placeID) {
			[weak self]
			(placeDetails, error)
			in
			guard let blockSelf = self
				else {
					return
			}
			runInMainQueue {
				blockSelf.activityIndicator.stopAnimating()
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
				blockSelf.loadPlaceDetails()
			}
		}
	}

	func loadPlaceDetails(){
		self.errorView?.removeFromSuperview()
		self.tableView.reloadData()
	}

	func showError(error:NSError){
		if self.errorView == nil {
			let errorController = PNBErrorViewController(error: error, delgateToErrorController:self)
			self.addChildViewController(errorController)
			errorView = errorController.view
		}
		self.addFittingSubviewViewInContainer(view: errorView!)
	}

	private func addFittingSubviewViewInContainer(view:UIView) {
		self.tableContainerView.addSubview(view)
		view.translatesAutoresizingMaskIntoConstraints = false
		let left = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.tableContainerView, attribute: NSLayoutAttribute.left, multiplier: 1.0, constant: 0.0)
		let right = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.tableContainerView, attribute: NSLayoutAttribute.right, multiplier: 1.0, constant: 0.0)
		let top = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.tableContainerView, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 0.0)
		let bottom = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.tableContainerView, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0.0)
		NSLayoutConstraint.activate([left, right, top, bottom])
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
		return self.placeDetails!.numberOfRowNeeded
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

		if indexPath.row == 2 && (placeDetails!.shouldShowOpenNowRow) {
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
		if indexPath.row == 3 && placeDetails!.shouldShowCostRow {
			let cell = tableView.dequeueReusableCell(withIdentifier: costCellID, for: indexPath) as! PNBDetailsCostTableViewCell
			let costData = placeDetails!.costImageTextAndColor()
			cell.costImage.image = costData.image
			cell.costLabel.text = costData.cost
			cell.costLabel.textColor = costData.color
			let numberOfVisitorsDetails = placeDetails!.numberOfVisitorsDetails()
			cell.numberOfVisitorsLabel.textColor = numberOfVisitorsDetails.color
			cell.numberOfVisitorsLabel.text = numberOfVisitorsDetails.text
			cell.noOfVisitorsImage.image = numberOfVisitorsDetails.image
			return cell
		}

		if indexPath.row == 4 && self.placeDetails!.rating != nil{
			let cell = tableView.dequeueReusableCell(withIdentifier: topRowReviewID, for: indexPath) as! PNBReviewsTopTableViewCell
			let dataForRating = placeDetails!.ratingImageTextAndTextColor()
			cell.starImage?.image = dataForRating.image
			cell.ratingLabel.textColor = dataForRating.color
			cell.ratingLabel.text = dataForRating.ratingText
			cell.numberOfVisitorsLabel.text = dataForRating.visitorsText
			cell.layoutIfNeeded()
			return cell
		}

		if indexPath.row <= self.placeDetails!.numberOfRowNeeded && self.placeDetails?.reviews != nil{
			let cell = tableView.dequeueReusableCell(withIdentifier: reviewCellID, for: indexPath) as! PNBPlaceDetailsReviewsTableViewCell
			let data = self.placeDetails!.ratingTextAndColor(forIndex: indexPath.row)
			cell.name.text = data.name
			cell.rating.text = data.rating
			cell.rating.textColor = data.color
			cell.review.text = data.text
			return cell
		}
		let blankCell = tableView.dequeueReusableCell(withIdentifier: blankCellID, for: indexPath) as! PNBDetailsTableViewCell
		return blankCell
	}


	//MARK:Error delegate
	func didSelectedRetryForError(error: NSError) {
		tryToGetPlaceDetails()
	}


}
