//
//  PNBSingleImageViewController.swift
//  PlacesNearby
//
//  Created by Abhishek on 20/11/16.
//  Copyright © 2016 Abhishek. All rights reserved.
//

import UIKit

class PNBSingleImageViewController: UIViewController, URLSessionTaskDelegate {


	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	@IBOutlet weak var imageView: UIImageView!
	let photoReference:String
	var imageDownLoadTask:URLSessionDownloadTask?
	let index:Int

	init(reference:String, index:Int){
		self.photoReference = reference
		self.index = index
		super.init(nibName: "PNBSingleImageViewController", bundle: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		Swift.print("view did load called")
        super.viewDidLoad()
		view.layer.backgroundColor = UIColor(red: 178/255, green: 174/255, blue: 180/255, alpha: 0.20).cgColor
		view.layer.borderWidth = 1.0
		view.layer.borderColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 0.20).cgColor
		activityIndicator.startAnimating()
		startDownloadingImage()
    }

	private func startDownloadingImage(){
		let session = URLSession.init(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
		let screenWidth = Int(UIScreen.main.bounds.width)
		let url = PNBApiManager.getUrlForPhtotoDowload(photoReference: photoReference, maxHeight: 200, maxWidth: screenWidth)
		imageDownLoadTask = session.downloadTask(with: url as URL, completionHandler: {
			[weak self]
			(url, response, error)
			in
			guard let blockSelf = self
				else{
					return
			}
			if error != nil {
				Swift.print(error)
				return
			}
			let data = NSData(contentsOf: url!)!
			let image = UIImage(data: data as Data)
			runInMainQueue {
				blockSelf.activityIndicator.stopAnimating()
				blockSelf.setImageAndUI(image: image)

			}
		})
		imageDownLoadTask?.resume()


	}
	deinit {
		imageDownLoadTask?.suspend()
	}

	private func setImageAndUI(image:UIImage?){
		view.layer.backgroundColor = UIColor.clear.cgColor
		view.layer.borderWidth = 0.0
		self.imageView.image = image
	}

	public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL)
	{
		let data = NSData(contentsOf: location)!
		let image = UIImage(data: data as Data)
		runInMainQueue {
			[weak self]
			in
			if let blockSelf = self{
				blockSelf.activityIndicator.stopAnimating()
				blockSelf.setImageAndUI(image: image)
			}
		}
	}



}
