//
//  PNHeaderView.swift
//  PlacesNearby
//
//  Created by Abhishek on 03/11/16.
//  Copyright © 2016 Abhishek. All rights reserved.
//

import UIKit

class PNHeaderView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

	override init(frame: CGRect) {
		super.init(frame: frame)
		setUp()
	}

	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setUp()
	}

	 func setUp() {
		self.layer.borderWidth = 1.0
		self.layer.borderColor = UIColor(red: 98/255, green: 205/255, blue: 138/255, alpha: 1.0).cgColor
		self.layer.shadowColor = UIColor.black.cgColor
		self.layer.shadowOpacity = 0.25
		self.layer.shadowOffset = CGSize.zero
		self.layer.shadowRadius = 5
		self.layer.shadowOffset = CGSize.zero
	}

}
