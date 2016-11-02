//
//  PNCategoriesData.swift
//  PlacesNearby
//
//  Created by Abhishek on 02/11/16.
//  Copyright © 2016 Abhishek. All rights reserved.
//

import Foundation

enum PlaceType{

	case Food,
	Hotel,
	Police,
	Medical,
	Bank,
	GasStation,
	Parking,
	TrainStation,
	BusStation,
	Car,
	Shopping,
	Laundry,
	LocalSee,
	Movies,
	Books,
	Liquor,
	Beauty,
	Offline

	var placesDetails:PlacesCategory {
		switch self {
		case .Food:
			return PlacesCategory(imageName: "PlacesFood", placeTitle: "Food", placeSubtitle: "Resturents, Cafe, Bakery")

		case .Hotel:
			return PlacesCategory(imageName: "PlacesHotel", placeTitle: "Hotel", placeSubtitle: "Hotel, Lodging, Stay")

		case .Police:
			return PlacesCategory(imageName: "PlacesPolice", placeTitle: "Police", placeSubtitle: "Police station, Help")

		case .Medical:
			return PlacesCategory(imageName: "PlacesMedical", placeTitle: "Medical", placeSubtitle: "Doctor, Hospital, Pharmacy")

		case .Bank:
			return PlacesCategory(imageName: "PlacesBank", placeTitle: "Bank", placeSubtitle: "Bank, Atm, Accounting")

		case .GasStation:
			return PlacesCategory(imageName: "PlacesGasStation", placeTitle: "Gas Station", placeSubtitle: "Petrol, Diesel, Gas, Fuel")

		case .Parking:
			return PlacesCategory(imageName: "PlacesParking", placeTitle: "Parking", placeSubtitle: "Car parking, RV Parking")

		case .TrainStation:
			return PlacesCategory(imageName: "PlacesTrainStation", placeTitle: "Train Station", placeSubtitle: "Train, Transit, Subway")

		case .BusStation:
			return PlacesCategory(imageName: "PlacesBusStation", placeTitle: "Bus Station", placeSubtitle: "Bus Station, Taxi Stand")

		case .Car:
				return PlacesCategory(imageName: "PlacesCar", placeTitle: "Car", placeSubtitle: "Car Dealer, Repair, Wash")

		case .Shopping:
			return PlacesCategory(imageName: "PlacesShopping", placeTitle: "Shopping", placeSubtitle: " Grocery, Electronics, Tools")

		case .Laundry:
			return PlacesCategory(imageName: "PlacesLaundry", placeTitle: "Laundry", placeSubtitle: "Clothing, Laundry")

		case .LocalSee:
			return PlacesCategory(imageName: "PlacesLocalSee", placeTitle: "Local See", placeSubtitle: "Local seeable places")

		case .Movies:
			return PlacesCategory(imageName: "PlacesMovies", placeTitle: "Movies", placeSubtitle: "Movie rental, Theater")

		case .Books:
			return PlacesCategory(imageName: "PlacesBooks", placeTitle: "Books", placeSubtitle: "Books store, Library")

		case .Liquor:
			return PlacesCategory(imageName: "PlacesLiquor", placeTitle: "Liquor", placeSubtitle: "Store, Bar, Night club")

		case .Beauty:
			return PlacesCategory(imageName: "PlacesBeauty", placeTitle: "Beauty", placeSubtitle: "Local beauty salon")

		case .Offline:
			return PlacesCategory(imageName: "PlacesOffline", placeTitle: "Offline", placeSubtitle: "Places saved offline")
		}

	}

}

struct PlacesCategory{
	let imageName:String
	let placeTitle:String
	let placeSubtitle:String
}

class PNCategoriesData{

	let listOfPlacesCategory:[PlaceType] = [
	.Food,
	.Hotel,
	.Police,
	.Medical,
	.Bank,
	.GasStation,
	.Parking,
	.TrainStation,
	.BusStation,
	.Car,
	.Shopping,
	.Laundry,
	.LocalSee,
	.Movies,
	.Books,
	.Liquor,
	.Beauty,
	.Offline
	]
}
