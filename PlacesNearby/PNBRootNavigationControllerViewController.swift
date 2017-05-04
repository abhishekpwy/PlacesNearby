//
//  PNBRootNavigationControllerViewController.swift
//  PlacesNearby
//
//  Created by Abhishek Pandey on 04/05/17.
//  Copyright © 2017 Abhishek. All rights reserved.
//

import UIKit

class PNBRootNavigationControllerViewController: UINavigationController, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
