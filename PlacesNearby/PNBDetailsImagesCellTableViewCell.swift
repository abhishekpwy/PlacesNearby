//
//  PNBDetailsImagesCellTableViewCell.swift
//  PlacesNearby
//
//  Created by Abhishek on 19/11/16.
//  Copyright © 2016 Abhishek. All rights reserved.
//

import UIKit

class PNBDetailsImagesCellTableViewCell: UITableViewCell,  UIPageViewControllerDelegate, UIPageViewControllerDataSource {
	@IBOutlet weak var containerImage: UIView!
	@IBOutlet weak var errorLoadingImage: UIImageView!
	@IBOutlet weak var labelForErorr: UILabel!
	var listOfPhotoReferences:[String]?
	weak var parentController:PNBPlaceDetailsViewController?
	var controllers:[PNBSingleImageViewController]?


    override func awakeFromNib() {
        super.awakeFromNib()
		errorLoadingImage.isHidden = true
		labelForErorr.isHidden = true
		containerImage.layer.backgroundColor = UIColor(red: 178/255, green: 174/255, blue: 180/255, alpha: 0.20).cgColor
		containerImage.layer.borderWidth = 1.0
		containerImage.layer.borderColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 0.20).cgColor
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

	final func loadListOfPhotos(photoReferences:[String]?, parentController:PNBPlaceDetailsViewController){
		self.parentController = parentController
		if photoReferences == nil {
			loadErrorState()
			return
		}
		self.listOfPhotoReferences = photoReferences
		addPageViewControllerForImages()
	}

	private func addPageViewControllerForImages(){
		addControllers()
		let pageController = PNBPageDetailsPageViewController(listOfPhotoReferences: self.listOfPhotoReferences!)
		pageController.delegate = self
		pageController.dataSource = self
		let intialViewController = viewControllerAtIndex(index: 0)
		pageController.setViewControllers([intialViewController!], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
		self.addFittingSubviewViewInContainer(view: pageController.view)
		parentController!.addChildViewController(pageController)
		pageController.didMove(toParentViewController: parentController!)
	}

	private func addControllers(){
		var controllerList = [viewControllerAtIndex(index: 0)!]
		for (index, _) in listOfPhotoReferences!.enumerated()
		{
			if index > 0 {
				controllerList.append(viewControllerAtIndex(index: index)!)
			}
		}
		self.controllers = controllerList
	}

	private func addFittingSubviewViewInContainer(view:UIView) {
		self.addSubview(view)
		view.translatesAutoresizingMaskIntoConstraints = false
		let left = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.containerImage, attribute: NSLayoutAttribute.left, multiplier: 1.0, constant: 0.0)
		let right = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.containerImage, attribute: NSLayoutAttribute.right, multiplier: 1.0, constant: 0.0)
		let top = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.containerImage, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 0.0)
		let bottom = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.containerImage, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0.0)
		NSLayoutConstraint.activate([left, right, top, bottom])
	}

	private func loadErrorState(){
		self.errorLoadingImage.isHidden = false
		self.labelForErorr.isHidden = false
	}


	private func viewControllerAtIndex(index:Int) -> PNBSingleImageViewController?{
		guard index >= 0 && index < self.listOfPhotoReferences!.count
			else {
				return nil
		}
		if let controllers = self.controllers {
			return controllers[index]
		}
		let reference = listOfPhotoReferences![index]
		let singleImageViewController = PNBSingleImageViewController(reference: reference, index: index)
		return singleImageViewController
	}

	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
		let index = (viewController as! PNBSingleImageViewController).index
		return viewControllerAtIndex(index: index + 1)
	}

	func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
		let index = (viewController as! PNBSingleImageViewController).index
		return viewControllerAtIndex(index: index - 1)
	}

	func presentationCount(for pageViewController: UIPageViewController) -> Int {
		return self.listOfPhotoReferences!.count
	}

	func presentationIndex(for pageViewController: UIPageViewController) -> Int {
		return 0
	}
}
