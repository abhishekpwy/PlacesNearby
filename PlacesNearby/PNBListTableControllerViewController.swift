//
//  PNBListTableControllerViewController.swift
//  PlacesNearby
//
//  Created by Abhishek on 12/11/16.
//  Copyright © 2016 Abhishek. All rights reserved.
//

import UIKit

class PNBListTableControllerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	@IBOutlet weak var tableView: UITableView!
	var listOfPlaces:[PlaceDataForListAndMap]

	init(listOfPlaces:[PlaceDataForListAndMap]){
		self.listOfPlaces = listOfPlaces
		super.init(nibName: "PNBListTableControllerViewController", bundle: nil)
	}

	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
		self.tableView.estimatedRowHeight = 90
		self.tableView.rowHeight = UITableViewAutomaticDimension
		tableView.register(UINib(nibName: "PNBListTableViewCell", bundle: nil), forCellReuseIdentifier: "PNBCell")
		tableView.register(UINib(nibName: "PNBLoadMoreTableViewCell", bundle: nil), forCellReuseIdentifier: "loadMoreCell")
    }

	final func updateListOfPlacesFromParent(){
		self.listOfPlaces = (self.parent as! PNBListOfResultViewController).listOfPlacesFromApi!
		self.tableView.reloadData()
	}

	private func getImageForDistance(distance:Double)-> (image:UIImage, colorForText:UIColor) {
		let currentMaxSearchDistance = PNBUserDefaultManager().getValueObject(key: PNBUserDefaultManager.KeysForUserDefault.radiusOfSearch) as! Int
		let halfDistance = Double(currentMaxSearchDistance/2)
		let quartrDistance = Double(currentMaxSearchDistance/4)
		let threeFourth = Double((3 * currentMaxSearchDistance)/4)
		if distance < quartrDistance {
			let image = UIImage(named: "Distance1")!
			let color =  UIColor(red: 65/255, green: 117/255, blue: 5/255, alpha: 1.0)
			return (image, color)
		}else if distance < halfDistance {
			let image = UIImage(named: "Distance2")!
			let color =  UIColor(red: 90/255, green: 160/255, blue: 14/255, alpha: 1.0)
			return (image, color)
		}else if distance < threeFourth {
			let image = UIImage(named: "Distance3")!
			let color =  UIColor(red: 245/255, green: 166/255, blue: 35/255, alpha: 1.0)
			return (image, color)
		}
		let image = UIImage(named: "Distance4")!
		let color =  UIColor(red: 208/255, green: 2/255, blue: 27/255, alpha: 1.0)
		return (image, color)
	}

	private func textColorAndImageForOpenNow(isOpen:Bool?) -> (text:String, color:UIColor, image:UIImage){
		guard let boolValue = isOpen
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

	private func loadMoreInParentAndSelf(){
		(parent as! PNBListOfResultViewController).loadMore {
			[weak self]
			(success, list)
			in
			guard let blockSelf = self
				else{
					return
			}
			if success {
					blockSelf.listOfPlaces = list!
				runInMainQueue {
					blockSelf.tableView.reloadData()
				}
			}

		}
	}

	private func loadDetailsControllerWithID(placeID:String){
		let detailsController = PNBPlaceDetailsViewController(placeID: placeID)
		self.navigationController?.pushViewController(detailsController, animated: true)
	}

	//MARK:Table data source
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if (parent as! PNBListOfResultViewController).hasMoreToLoad {
			return listOfPlaces.count + 1 //one load more cell
		}
		return listOfPlaces.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.row == self.listOfPlaces.count{
			let cell = tableView.dequeueReusableCell(withIdentifier: "loadMoreCell", for: indexPath) as! PNBLoadMoreTableViewCell
			return cell
		}
		let cell = tableView.dequeueReusableCell(withIdentifier: "PNBCell", for: indexPath) as! PNBListTableViewCell
		let dataForRow = self.listOfPlaces[indexPath.row]
		cell.nameOfPlace.text = dataForRow.nameOfPlace
		cell.vicinityOfPlace.text = dataForRow.addressOfPlace
		let ratingData = dataForRow.imageTextAndTextColorForRating()
		cell.ratingLabel.text = ratingData.text
		cell.ratingImageView.image = ratingData.image
		cell.ratingLabel.textColor = ratingData.colorForText
		cell.distanceLabel.text = String(String(format: "%.1f KM", dataForRow.distanceFromCurrentLocation))
		let colorAndImageForDistance = getImageForDistance(distance: dataForRow.distanceFromCurrentLocation)
		cell.distanceLabel.textColor = colorAndImageForDistance.colorForText
		cell.distanceImageView.image = colorAndImageForDistance.image
		let openNowData = dataForRow.textColorAndImageForOpenNow()
		cell.openNowLabel.textColor = openNowData.color
		cell.openNowLabel.text = openNowData.text
		cell.openNowImageView.image = openNowData.image
		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.row == self.listOfPlaces.count {
			//it is loadmore row
			loadMoreInParentAndSelf()
			return
		}
		let placeID = self.listOfPlaces[indexPath.row].placeID
		loadDetailsControllerWithID(placeID: placeID)
	}
}
