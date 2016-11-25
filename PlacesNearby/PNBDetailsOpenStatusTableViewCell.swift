//
//  PNBDetailsOpenStatusTableViewCell.swift
//  PlacesNearby
//
//  Created by Abhishek on 20/11/16.
//  Copyright © 2016 Abhishek. All rights reserved.
//

import UIKit

class PNBDetailsOpenStatusTableViewCell: UITableViewCell {


	@IBOutlet weak var openStatueLabel: UILabel!
	@IBOutlet weak var openTimingLabel: UILabel!
	@IBOutlet weak var pnNoLabel: UILabel!
	@IBOutlet weak var websiteUrlButton: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
	@IBAction func didSelectedCall(_ sender: Any) {
		if self.pnNoLabel.text != "Phone Number not shared"{
			let phoneNumber = self.pnNoLabel.text!.replacingOccurrences(of: " ", with: "")
			UIApplication.shared.open(NSURL(string:"telprompt://\(phoneNumber)") as! URL , options: [:], completionHandler: nil)
		}
	}

	@IBAction func didSelectedOpenWebsite(_ sender: Any) {
		if (self.websiteUrlButton.text?.characters.count)! > 0 {
			UIApplication.shared.open(NSURL(string:self.websiteUrlButton.text!) as! URL , options: [:], completionHandler: nil)
		}
	}

}
