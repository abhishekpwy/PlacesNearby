//
//  PNBErrorViewController.swift
//  PlacesNearby
//
//  Created by Abhishek on 16/11/16.
//  Copyright © 2016 Abhishek. All rights reserved.
//

import UIKit

class PNBErrorViewController: UIViewController {

	@IBOutlet weak var errorDiscriptionLabel: UILabel!
	@IBOutlet weak var imageForError: UIImageView!
	@IBOutlet weak var errorButton: UIButton!
	let errorForController:NSError

	init(error:NSError){
		self.errorForController = error
		super.init(nibName: "PNBErrorViewController", bundle: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.setTitleAndImage()
		self.errorButton.layer.backgroundColor = UIColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0).cgColor
		self.errorButton.layer.borderWidth = 1.0
		self.errorButton.layer.borderColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 0.2).cgColor
		self.errorButton.layer.cornerRadius = self.errorButton.frame.height/2
		self.errorButton.setTitleColor(UIColor.white, for: UIControlState.normal)
		setTitleAndImage()
    }

	private func setTitleAndImage(){
		var discriptionForError = ""
		var imageToShow = UIImage(named: "SadFace")
		var buttonTitle = "Retry"
		switch errorForController.code {
		case PNBErrorCodes.InternetNotAvailable.rawValue:
			discriptionForError = "No Internet? \n We need internet to fetch places around you!"
			imageToShow = UIImage(named: "NoInternet")
		case PNBErrorCodes.locationNotAvailableError.rawValue, PNBErrorCodes.locationServiceDisabled.rawValue:
			discriptionForError = "Location Disabled? \n We need it to get your current location!"
			imageToShow = UIImage(named: "LocationDisabled")
		case PNBErrorCodes.listOfPlacesFromApiEmpty.rawValue, PNBErrorCodes.statusCodeNot200.rawValue:
			discriptionForError = "Oops! \n We can't find any relevant places around you :("
			buttonTitle = "Modify Search"
		default:
			discriptionForError = errorForController.localizedDescription
		}
		self.imageForError.image = imageToShow
		self.errorDiscriptionLabel.text = discriptionForError
		self.errorButton.setTitle(buttonTitle, for: UIControlState.normal)
	}
}
