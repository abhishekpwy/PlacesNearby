//
//  PNBListOfResultViewController.swift
//  PlacesNearby
//
//  Created by Abhishek on 11/11/16.
//  Copyright © 2016 Abhishek. All rights reserved.
//

import UIKit
import CoreLocation

class PlaceDataForListAndMap {
	let placeID:String
	let nameOfPlace:String
	let addressOfPlace:String
	let isOpenNow:Bool?
	let currentLocation:CLLocation
	let distanceFromCurrentLocation:Double
	let rating:Double
	init(placeID:String, nameOfPlace:String, addressOfPlace:String, isOpenNow:Bool?, location: CLLocation, distanceFromCurrentLocation:Double,  rating:Double){
		self.placeID = placeID
		self.nameOfPlace = nameOfPlace
		self.addressOfPlace = addressOfPlace
		self.isOpenNow = isOpenNow
		self.distanceFromCurrentLocation = distanceFromCurrentLocation
		self.rating = rating
		self.currentLocation = location
	}
}

class PNBListOfResultViewController: UIViewController {
	let currentPlaceType:PlaceType
	@IBOutlet weak var backButton: UIButton!
	@IBOutlet weak var placeTopImage: UIImageView!
	@IBOutlet weak var placesHeaderLabel: UILabel!
	@IBOutlet weak var containerView: UIView!
	var listOfPlacesFromApi:[PlaceDataForListAndMap]?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
		setUpIntialUI()
		tryToFetchListOfPlacesNearBy()

    }

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}

	private func setUpIntialUI(){
		self.placeTopImage.image = currentPlaceType.imageForHeader
		self.placesHeaderLabel.text = currentPlaceType.title + " Near By"
	}


	init(placesType:PlaceType){
		self.currentPlaceType = placesType
		super.init(nibName: "PNBListOfResultViewController", bundle: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func tryToFetchListOfPlacesNearBy(){
		PNBDataManager.sharedDataManager.fetchListOfPlaces(placeType: self.currentPlaceType) {
			[weak self]
			(listOfPlaces, error)
			in
			guard let blockSelf = self
				else{
					return
			}
			//
			runInMainQueue {
				blockSelf.listOfPlacesFromApi = listOfPlaces
				Swift.print(error)
				blockSelf.addControllerForList(withPlaces: listOfPlaces!)
			}
		}
	}

	

	@IBAction func didClickBackButton(_ sender: AnyObject) {
		self.navigationController?.popViewController(animated: true)
	}

	private func addControllerForList(withPlaces:[PlaceDataForListAndMap]){
		let listViewController = PNBListTableControllerViewController(listOfPlaces: withPlaces)
		self.replaceOrAddViewController(viewController: listViewController)
	}

	private func replaceOrAddViewController(viewController:UIViewController) {
		if self.childViewControllers.count == 0{
			self.addChildViewController(viewController)
			self.addFittingSubviewViewInContainer(view: viewController.view)
			return
		}
		self.childViewControllers[0].removeFromParentViewController()
		self.childViewControllers[0].view.removeFromSuperview()
		self.addChildViewController(viewController)
		self.addFittingSubviewViewInContainer(view: viewController.view)
	}

	private func addFittingSubviewViewInContainer(view:UIView) {
		self.containerView.addSubview(view)
		view.translatesAutoresizingMaskIntoConstraints = false
		let left = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.containerView, attribute: NSLayoutAttribute.left, multiplier: 1.0, constant: 0.0)
		let right = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.containerView, attribute: NSLayoutAttribute.right, multiplier: 1.0, constant: 0.0)
		let top = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.containerView, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 0.0)
		let bottom = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.containerView, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0.0)
		NSLayoutConstraint.activate([left, right, top, bottom])
	}

}

func runInMainQueue(block:@escaping (() -> Void)){
	DispatchQueue.main.async {
		block()
	}
}
