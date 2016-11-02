//
//  ViewController.swift
//  PlacesNearby
//
//  Created by Abhishek on 02/11/16.
//  Copyright © 2016 Abhishek. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	let reuseIdentifier = "places"
	let itemsPerRow:CGFloat = 2
	let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
	let data = PNCategoriesData().listOfPlacesCategory

	@IBOutlet weak var placesCollectionView: UICollectionView!
	override func viewDidLoad() {
		super.viewDidLoad()
		let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
		layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		layout.itemSize = CGSize(width: self.view.frame.width / 2, height: 134)
		layout.minimumInteritemSpacing = 0
		layout.minimumLineSpacing = 0
		placesCollectionView!.collectionViewLayout = layout
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}

}

extension ViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return data.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
		                                              for: indexPath) as! PNCollectionViewCell
		cell.backgroundColor = UIColor.white
		let dataAtIndex = data[indexPath.row]
		cell.placesImage.image = UIImage(named: dataAtIndex.placesDetails.imageName)
		cell.placesTitle.text = dataAtIndex.placesDetails.placeTitle
		cell.placesSubtitle.text = dataAtIndex.placesDetails.placeSubtitle
		cell.setBorderColorToSomething()
		return cell
	}
}

