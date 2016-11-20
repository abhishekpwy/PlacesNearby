//
//  PNBPageDetailsPageViewController.swift
//  PlacesNearby
//
//  Created by Abhishek on 20/11/16.
//  Copyright © 2016 Abhishek. All rights reserved.
//

import UIKit

class PNBPageDetailsPageViewController: UIPageViewController {

	let listOfPhotoReferences:[String]
	
	init(listOfPhotoReferences:[String]){
		self.listOfPhotoReferences = listOfPhotoReferences

		super.init(transitionStyle: UIPageViewControllerTransitionStyle.scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.horizontal, options: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()

		var subViews: NSArray = view.subviews as NSArray
		var scrollView: UIScrollView? = nil
		var pageControl: UIPageControl? = nil

		for view in subViews {
			if (view is (UIScrollView)) {
				scrollView = view as? UIScrollView
			}
			else if view is (UIPageControl) {
				pageControl = view as? UIPageControl
			}
		}

		if (scrollView != nil && pageControl != nil) {
			scrollView?.frame = view.bounds
			view.bringSubview(toFront: pageControl!)
		}
	}

	override func viewDidLoad() {
        super.viewDidLoad()
    }



}
