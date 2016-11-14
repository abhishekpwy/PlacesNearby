//
//  PNBMapViewController.swift
//  PlacesNearby
//
//  Created by Abhishek on 14/11/16.
//  Copyright © 2016 Abhishek. All rights reserved.
//

import UIKit
import MapKit

protocol DetailsViewProtocol:class {
	func didTapOnDetailsViewWithID(placeID:String)
}

class PNBMapViewController: UIViewController, MKMapViewDelegate, DetailsViewProtocol {
	@IBOutlet weak var mapView: MKMapView!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	var listOfPlaces:[PlaceDataForListAndMap]

	init(listOfPlaces:[PlaceDataForListAndMap]){
		self.listOfPlaces = listOfPlaces
		super.init(nibName: "PNBMapViewController", bundle: nil)
	}


	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func addAnnotationForListOfPlaces(){
		var annoationArray = [PNBAnnotation]()
		for item in listOfPlaces{
			let annotaion = PNBAnnotation(placeDetails: item)
			annoationArray.append(annotaion)
		}
		self.mapView.showAnnotations(annoationArray, animated: true)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		mapView.delegate = self
		mapView.showsUserLocation = true
	}

	func configureDetailsView(annotationView:PNBAnnotationView, placeDetails:PlaceDataForListAndMap){
		let viewForDetails = PNBMapDetailView.instanceFromNib()
		let views = ["viewForDetails": viewForDetails]
		viewForDetails.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[viewForDetails(150)]", options: [], metrics: nil, views: views))
		viewForDetails.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[viewForDetails(55)]", options: [], metrics: nil, views: views))
		viewForDetails.setImageAndLablesForPlaceDetails(placeDetails: placeDetails, withDelgate: self)
		 annotationView.detailCalloutAccessoryView = viewForDetails
	}

	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		if annotation is MKUserLocation {
			return nil
		}
		let identifier = "PNBCustomAnnotaion"
		var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
		if annotationView == nil {
			annotationView = PNBAnnotationView(annotation: annotation, reuseIdentifier: identifier)
			annotationView?.image = UIImage(named: "pin")
			annotationView?.canShowCallout = true
		} else {
			annotationView!.annotation = annotation
		}
		configureDetailsView(annotationView: annotationView as! PNBAnnotationView, placeDetails: (annotation as! PNBAnnotation).placeDetails)
		return annotationView
	}

	func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
		activityIndicator.stopAnimating()
		self.addAnnotationForListOfPlaces()
	}

	func didTapOnDetailsViewWithID(placeID: String) {
		Swift.print(placeID)
	}
}
