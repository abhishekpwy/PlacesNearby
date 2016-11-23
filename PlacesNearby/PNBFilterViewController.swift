//
//  PNBFilterViewController.swift
//  PlacesNearby
//
//  Created by Abhishek on 22/11/16.
//  Copyright © 2016 Abhishek. All rights reserved.
//

import UIKit
protocol FilterDelegate:class {
	func didApplyFilter(hasRadiusChanged:Bool)
	func didCloseWithoutFilter()
}

enum SortingMethod:Int {
	case distance, rating
}

enum MapType:Int {
	case standard, satelite, terrain
}

class PNBFilterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {


	@IBOutlet weak var tableView: UITableView!
	var distanceSettingsCell:PNBFilterSearchDistanceTableViewCell?
	let distanceSettingsCellID = "PNBSearchDistanceCell"

	var sortByCell:PNBSortByTableViewCell?
	let sortByCellID = "PNBSortByTableViewCell"
	weak var delegate:FilterDelegate?

	var mapTypeCellID = "PNBMapTypeTableViewCell"
	var mapTypeCell:PNBMapTypeTableViewCell?

	init(delegate:FilterDelegate){
		self.delegate = delegate
		super.init(nibName: "PNBFilterViewController", bundle: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
    override func viewDidLoad() {
        super.viewDidLoad()
		self.tableView.estimatedRowHeight = 90
		self.tableView.rowHeight = UITableViewAutomaticDimension
		tableView.register(UINib(nibName: "PNBFilterSearchDistanceTableViewCell", bundle: nil), forCellReuseIdentifier: distanceSettingsCellID)
		tableView.register(UINib(nibName: "PNBSortByTableViewCell", bundle: nil), forCellReuseIdentifier: sortByCellID)
		tableView.register(UINib(nibName: "PNBMapTypeTableViewCell", bundle: nil), forCellReuseIdentifier: mapTypeCellID)
    }


	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}

	@IBAction func didSelectedApplyFilter(_ sender: Any) {
		var hasValueChanged = false
		var hasDistanceChanged = false
		if self.distanceSettingsCell!.intialValue != Int(self.distanceSettingsCell!.slider.value){
			PNBUserDefaultManager().setValueForObject(value: Int(self.distanceSettingsCell!.slider.value) as AnyObject?, forKey: PNBUserDefaultManager.KeysForUserDefault.radiusOfSearch)
			hasDistanceChanged = true
			hasValueChanged = true
		}

		if self.sortByCell!.initialSortingMethod != self.sortByCell!.getCurrentState() {
			PNBUserDefaultManager().setValueForObject(value: self.sortByCell!.getCurrentState() as AnyObject?, forKey: PNBUserDefaultManager.KeysForUserDefault.sortBy)
			hasValueChanged = true
		}

		if self.mapTypeCell!.intialValue != self.mapTypeCell!.getValueForMapType() {
			PNBUserDefaultManager().setValueForObject(value: self.mapTypeCell!.getValueForMapType() as AnyObject?, forKey: PNBUserDefaultManager.KeysForUserDefault.mapType)
			hasValueChanged = true
		}

		closeView(hasValueChanged: hasValueChanged, hasRadiusChanged: hasDistanceChanged)
	}

	@IBAction func didSelectedCancelFilter(_ sender: Any) {
		closeView(hasValueChanged: false, hasRadiusChanged: false)
	}

	private func closeView(hasValueChanged:Bool, hasRadiusChanged:Bool){
		self.dismiss(animated: true) { 
			[weak self]
			in
			if let blockSelf = self {
				if hasValueChanged{
					blockSelf.delegate?.didApplyFilter(hasRadiusChanged: hasRadiusChanged)
				}
			}
		}
	}

	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 3
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.row == 0 {
			let cell = tableView.dequeueReusableCell(withIdentifier: distanceSettingsCellID, for: indexPath) as! PNBFilterSearchDistanceTableViewCell
			self.distanceSettingsCell = cell
			return cell
		}else if indexPath.row == 1{
			let cell = tableView.dequeueReusableCell(withIdentifier: sortByCellID, for: indexPath) as! PNBSortByTableViewCell
			self.sortByCell = cell
			return cell
		}

		let cell = tableView.dequeueReusableCell(withIdentifier: mapTypeCellID, for: indexPath) as! PNBMapTypeTableViewCell
		self.mapTypeCell = cell
		return cell

	}
	
}
