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
	let location:CLLocation
	let distanceFromCurrentLocation:Double
	let rating:Double
	init(placeID:String, nameOfPlace:String, addressOfPlace:String, isOpenNow:Bool?, location: CLLocation, distanceFromCurrentLocation:Double,  rating:Double){
		self.placeID = placeID
		self.nameOfPlace = nameOfPlace
		self.addressOfPlace = addressOfPlace
		self.isOpenNow = isOpenNow
		self.distanceFromCurrentLocation = distanceFromCurrentLocation
		self.rating = rating
		self.location = location
	}

	public func textColorAndImageForOpenNow() -> (text:String, color:UIColor, image:UIImage){
		guard let boolValue = self.isOpenNow
			else{
				let text = "Unknown"
				let color = UIColor(red: 78/255, green: 71/255, blue: 81/255, alpha: 1.0)
				let image = UIImage(named: "IsOpenUnknown")!
				return (text, color, image)
		}

		if boolValue{
			let text = "Open Now"
			let color = UIColor(red: 65/255, green: 117/255, blue: 5/255, alpha: 1.0)
			let image = UIImage(named: "IsOpenNow")!
			return (text, color, image)
		}

		let text = "Closed Now"
		let color = UIColor(red: 208/255, green: 2/255, blue: 27/255, alpha: 1.0)
		let image = UIImage(named: "IsClosedNow")!
		return (text, color, image)
	}

	public func imageTextAndTextColorForRating() -> (text:String, colorForText:UIColor, image:UIImage){
		let rating = self.rating
		let text = String(String(self.rating))
		if rating < 2.0 {
			let color =  UIColor(red: 208/255, green: 2/255, blue: 27/255, alpha: 1.0)
			let image =  UIImage(named: "Rating1")!
			return (text!,color, image)
		}else if rating < 3.0 {
			let image =  UIImage(named: "Rating2")!
			let color = UIColor(red: 245/255, green: 166/255, blue: 35/255, alpha: 1.0)
			return (text!,color, image)
		}else if rating < 4.0 {
			let image =  UIImage(named: "Rating3")!
			let color = UIColor(red: 90/255, green: 160/255, blue: 14/255, alpha: 1.0)
			return (text!,color, image)
		}
		let image =  UIImage(named: "Rating4")!
		let color = UIColor(red: 65/255, green: 117/255, blue: 5/255, alpha: 1.0)
		return (text!,color, image)
	}
}

class PNBListOfResultViewController: UIViewController, ErrorControllerDelagte, FilterDelegate {
	let currentPlaceType:PlaceType
	let searchText:String?
	@IBOutlet weak var backButton: UIButton!
	@IBOutlet weak var placeTopImage: UIImageView!
	@IBOutlet weak var placesHeaderLabel: UILabel!
	@IBOutlet weak var containerView: UIView!
	@IBOutlet weak var bottomBarView: UIView!
	@IBOutlet weak var firstOptionButton: UIButton!
	@IBOutlet weak var secondOptionButton: UIButton!
	@IBOutlet weak var thirdOptionButton: UIButton!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	@IBOutlet weak var bottomBarBottomContraint: NSLayoutConstraint!
	var listOfPlacesFromApi:[PlaceDataForListAndMap]?
	var currentUi:currentUIState?
	var hasMoreToLoad = false
	enum currentUIState:Int{
		case list = 1,map = 2
	}

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
		setUpIntialUI()
		tryToFetchListOfPlacesNearBy()
		self.automaticallyAdjustsScrollViewInsets = false
    }

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}

	private func setUpIntialUI(){
		self.placeTopImage.image = currentPlaceType.imageForHeader
		self.placesHeaderLabel.text = currentPlaceType.title + " Near By"
		self.bottomBarView.layer.shadowColor = UIColor.black.cgColor
		self.bottomBarView.layer.shadowOpacity = 0.09
		self.bottomBarView.layer.shadowOffset = CGSize(width: 0, height: -1)
		self.bottomBarView.layer.shadowRadius = 5
	}


	init(placesType:PlaceType, searchText:String? = nil){
		self.currentPlaceType = placesType
		self.searchText = searchText
		super.init(nibName: "PNBListOfResultViewController", bundle: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func tryToFetchListOfPlacesNearBy(){
		if self.currentPlaceType == .SearchPlaces{
			tryFetchingListOfPlcesForSearch()
		}else {
			teyFetchingListOfPlacesForPlaceType()
		}
	}

	private func tryFetchingListOfPlcesForSearch() {
		self.activityIndicator.isHidden = false
		self.activityIndicator.startAnimating()
		PNBDataManager.sharedDataManager.fetchListOfPlacesFromTextSearch(searchText: self.searchText!) {
			[weak self]
			(listOfPlaces, error)
			in
			guard let _ = self
				else{
					return
			}
			runInMainQueue {
				[weak self]
				in
				guard let blockSelf = self
					else{
						return
				}
				blockSelf.activityIndicator.stopAnimating()
				if error != nil {
					blockSelf.checkErrorAndShowErrorView(error: error!)
					return
				}
				//succesfully found more than one location
				if let _ = PNBUserDefaultManager().getValueObject(key: PNBUserDefaultManager.KeysForUserDefault.nextPageToken) as? String{
					blockSelf.hasMoreToLoad = true
				}else {
					blockSelf.hasMoreToLoad = false
				}
				blockSelf.listOfPlacesFromApi = listOfPlaces
				blockSelf.loadCurrentUIType(currentType: nil)
			}
		}
	}
	private func teyFetchingListOfPlacesForPlaceType(){
		self.activityIndicator.isHidden = false
		self.activityIndicator.startAnimating()
		PNBDataManager.sharedDataManager.fetchListOfPlaces(placeType: self.currentPlaceType) {
			[weak self]
			(listOfPlaces, error)
			in
			guard let _ = self
				else{
					return
			}
			runInMainQueue {
				[weak self]
				in
				guard let blockSelf = self
					else{
						return
				}
				blockSelf.activityIndicator.stopAnimating()
				if error != nil {
					blockSelf.checkErrorAndShowErrorView(error: error!)
					return
				}
				//succesfully found more than one location
				if let _ = PNBUserDefaultManager().getValueObject(key: PNBUserDefaultManager.KeysForUserDefault.nextPageToken) as? String{
					blockSelf.hasMoreToLoad = true
				}else {
					blockSelf.hasMoreToLoad = false
				}
				blockSelf.listOfPlacesFromApi = blockSelf.getSortedListAccordingToPreferences(listOfPlaces: listOfPlaces!)
				blockSelf.loadCurrentUIType(currentType: nil)
			}
		}
	}

	private func getSortedListAccordingToPreferences(listOfPlaces:[PlaceDataForListAndMap]) -> [PlaceDataForListAndMap]
	{
		let sortBy = PNBUserDefaultManager().getValueObject(key: PNBUserDefaultManager.KeysForUserDefault.sortBy) as! Int
		if sortBy == SortingMethod.rating.rawValue{
			let sortedArray = listOfPlaces.sorted(by: { (first, second) -> Bool in
				first.rating > second.rating
			})
			return sortedArray
		}
		let sortedArray = listOfPlaces.sorted(by: { (first, second) -> Bool in
			first.distanceFromCurrentLocation < second.distanceFromCurrentLocation
		})
		return sortedArray
	}

	final func loadMore(completion:@escaping (_ success:Bool, _ listOfPlacesFromApi:[PlaceDataForListAndMap]?) -> ()){
		self.activityIndicator.startAnimating()
		PNBDataManager.sharedDataManager.loadMorePlaces { [weak self]
			(listOfPlaces, error)
			in
			guard let blockSelf = self
				else{
					return
			}
			runInMainQueue {
				blockSelf.activityIndicator.stopAnimating()

			}
			if error != nil {
				completion(false, nil)
				return
			}
			if let _ = PNBUserDefaultManager().getValueObject(key: PNBUserDefaultManager.KeysForUserDefault.nextPageToken) as? String{
				blockSelf.hasMoreToLoad = true
			}else {
				blockSelf.hasMoreToLoad = false
			}
			for element in listOfPlaces! {
				blockSelf.listOfPlacesFromApi?.append(element)
			}
			blockSelf.listOfPlacesFromApi = blockSelf.getSortedListAccordingToPreferences(listOfPlaces: blockSelf.listOfPlacesFromApi!)
			completion(true, blockSelf.listOfPlacesFromApi)
		}
	}

	private func checkPreferencesAndReloadData(shouldReloadDataFromApi:Bool){
		if shouldReloadDataFromApi{
			tryToFetchListOfPlacesNearBy()
			return
		}
		self.listOfPlacesFromApi = getSortedListAccordingToPreferences(listOfPlaces: self.listOfPlacesFromApi!)

		if self.childViewControllers[0] is PNBMapViewController {
			 (self.childViewControllers[0] as! PNBMapViewController).updateMapTypeFromUserDefaults()

		}else if self.childViewControllers[0] is PNBListTableControllerViewController {
			(self.childViewControllers[0] as! PNBListTableControllerViewController).updateListOfPlacesFromParent()
		}

	}

	private func loadCurrentUIType(currentType:currentUIState?){
		let uiType = currentType?.rawValue ?? PNBUserDefaultManager().getValueObject(key: PNBUserDefaultManager.KeysForUserDefault.defaultUI) as! Int
		setBottomBarStateForSelection(currentType: currentUIState(rawValue: uiType)!)
		if uiType == currentUIState.list.rawValue{
			self.addControllerForList()
		} else {
			self.addMapViewController()
		}
	}

	private func setBottomBarStateForSelection(currentType:currentUIState){
		switch currentType {
		case .map:
			self.secondOptionButton.layer.backgroundColor = UIColor(red: 74/255, green: 211/255, blue: 122/255, alpha: 1.0).cgColor
			self.secondOptionButton.setImage(UIImage(named:"MapUiWhite") , for: UIControlState.normal)
			self.firstOptionButton.layer.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0).cgColor
			self.firstOptionButton.setImage(UIImage(named:"ListUI") , for: UIControlState.normal)
		case .list:
			self.firstOptionButton.layer.backgroundColor = UIColor(red: 74/255, green: 211/255, blue: 122/255, alpha: 1.0).cgColor
			self.firstOptionButton.setImage(UIImage(named:"ListUIWhite") , for: UIControlState.normal)
			self.secondOptionButton.layer.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0).cgColor
			self.secondOptionButton.setImage(UIImage(named:"MapUi") , for: UIControlState.normal)

		}
	}

	@IBAction func didClickBackButton(_ sender: AnyObject) {
		self.navigationController?.popViewController(animated: true)
	}
	@IBAction func didSelectedFirstOption(_ sender: Any) {
		if currentUi == currentUIState.list{
			return
		}
		loadCurrentUIType(currentType: currentUIState.list)
	}

	@IBAction func didSelectedSecondOption(_ sender: Any) {
		if currentUi == currentUIState.map{
			return
		}
		loadCurrentUIType(currentType: currentUIState.map)
	}
	
	@IBAction func didSelectedThirdOption(_ sender: Any) {
		showFilterOptions()
	}

	private func showFilterOptions(){
		let filterController = PNBFilterViewController(delegate: self)
		self.present(filterController, animated: true, completion: nil)
	}

	private func addControllerForList(){
		currentUi = currentUIState.list
		let listViewController = PNBListTableControllerViewController(listOfPlaces: self.listOfPlacesFromApi!)
		self.replaceOrAddViewController(viewController: listViewController)
		if self.bottomBarBottomContraint.constant < 0 {
			slideInBottomBar()
		}
	}

	private func slideInBottomBar(){
		self.bottomBarBottomContraint.constant = 0
		UIView.animate(withDuration: 0.5) {
			self.view.layoutIfNeeded()
		}
	}

	private func checkErrorAndShowErrorView(error:NSError){
		let errorController = PNBErrorViewController(error: error, delgateToErrorController:self)
		self.replaceOrAddViewController(viewController: errorController)
	}

	private func addMapViewController(){
		currentUi = currentUIState.map
		self.replaceOrAddViewController(viewController: PNBMapViewController(listOfPlaces:self.listOfPlacesFromApi!))
		if self.bottomBarBottomContraint.constant < 0 {
			slideInBottomBar()
		}
	}

	private func replaceOrAddViewController(viewController:UIViewController) {
		if self.childViewControllers.count == 0{
			self.addChildViewController(viewController)
			self.addFittingSubviewViewInContainer(view: viewController.view)
			return
		}
		self.childViewControllers[0].view.removeFromSuperview()
		self.childViewControllers[0].removeFromParentViewController()
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

	//MARK:Error delegate
	func didSelectedRetryForError(error: NSError) {
		//
		if error.domain == PNBErrorDomain {
			if error.code == PNBErrorCodes.listOfPlacesFromApiEmpty.rawValue{
				showFilterOptions()
			}
		}
		tryToFetchListOfPlacesNearBy()
	}

	//MARK:FilterDelegate
	func didApplyFilter(hasRadiusChanged:Bool) {
		checkPreferencesAndReloadData(shouldReloadDataFromApi: hasRadiusChanged)
	}
	func didCloseWithoutFilter() {
		
	}

}

func runInMainQueue(block:@escaping (() -> Void)){
	DispatchQueue.main.async {
		block()
	}
}
