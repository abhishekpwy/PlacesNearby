//
//  PNBTextSearchViewController.swift
//  PlacesNearby
//
//  Created by Abhishek on 21/11/16.
//  Copyright © 2016 Abhishek. All rights reserved.
//

import UIKit

class PNBTextSearchViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

	@IBOutlet weak var tableView: UITableView!
	var listOfSearchHistory = PNBUserDefaultManager().getValueObject(key: PNBUserDefaultManager.KeysForUserDefault.searchHisory) as! [String]
	@IBOutlet weak var searchContainerView: UIView!
	@IBOutlet weak var textSearchField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
		self.textSearchField.delegate = self
		self.searchContainerView.layer.borderWidth = 1.0
		self.searchContainerView.layer.borderColor = UIColor.white.cgColor
		self.searchContainerView.layer.cornerRadius = self.searchContainerView.frame.height/2
		self.tableView.estimatedRowHeight = 40
		self.tableView.rowHeight = UITableViewAutomaticDimension
		tableView.register(UINib(nibName: "PNBTextSearchHostoryCellTableViewCell", bundle: nil), forCellReuseIdentifier: "PNBTextSearchHostoryCellTableViewCell")
    }

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}

	override func viewDidAppear(_ animated: Bool) {
		self.textSearchField.becomeFirstResponder()
		refreshData()
	}
	@IBAction func didSelectedBackButton(_ sender: Any) {
		self.textSearchField.resignFirstResponder()
		self.navigationController?.popViewController(animated: true)
	}
	
	@IBAction func didTappedOnSearchButton(_ sender: Any) {
		self.textSearchField.becomeFirstResponder()
	}

	@IBAction func didEnterText(_ sender: Any) {

	}
	private func refreshData(){
		listOfSearchHistory = PNBUserDefaultManager().getValueObject(key: PNBUserDefaultManager.KeysForUserDefault.searchHisory) as! [String]
		self.tableView.reloadData()
	}

	private func searchForText(){
		guard let text = self.textSearchField.text, !text.isEmpty
			else{
				let alert = UIAlertController(title: "Oops!!", message: "Searh Query is Empty", preferredStyle: UIAlertControllerStyle.alert)
				alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
				self.present(alert, animated: true, completion: nil)
				return
		}
		self.textSearchField.resignFirstResponder()
		let placeDetailsController = PNBListOfResultViewController(placesType: PlaceType.SearchPlaces, searchText: text)
		self.navigationController?.pushViewController(placeDetailsController, animated: true)
		return
	}

	//MARK:text field delegate
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		searchForText()
		return true
	}

	//MARK: Table delegate

	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return listOfSearchHistory.count
	}


	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "PNBTextSearchHostoryCellTableViewCell", for: indexPath) as! PNBTextSearchHostoryCellTableViewCell
		cell.searchLabel.text = self.listOfSearchHistory[indexPath.row]
		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let text = listOfSearchHistory[indexPath.row]
		self.textSearchField.text = text
		searchForText()
	}
}
