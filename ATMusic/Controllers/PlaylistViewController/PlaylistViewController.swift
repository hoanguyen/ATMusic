//
//  PlaylistViewController.swift
//  ATMusic
//
//  Created by Nguyen Thanh Su on 8/1/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit
import SwiftUtils

class PlaylistViewController: UIViewController {
	// MARK: - private outlet
	@IBOutlet private weak var collectionView: UICollectionView!
	
	// MARK: - override func
	override func viewDidLoad() {
		super.viewDidLoad()
		configUI()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	// MARK: - private func
	private func configUI() {
		// delegate and datasource for collectionview
		collectionView.delegate = self
		collectionView.dataSource = self
		// register nib for cell, using library
		collectionView.registerNib(CustomCollectionViewCell)
		// set corner and shadow
		collectionView.backgroundColor = UIColor.clearColor()
		collectionView.layer.cornerRadius = 10.0
		collectionView.layer.shadowColor = UIColor.blackColor().CGColor
		collectionView.layer.shadowOffset = CGSize(width: 1, height: 1)
		collectionView.layer.shadowOpacity = 1
		collectionView.layer.shadowRadius = 1.0
		collectionView.clipsToBounds = true
		collectionView.layer.masksToBounds = true
		// set layout with number item on each row
		collectionView.setLayout(collectionSize: self.view.bounds.size, numberItemOfRow: 2, scrollDirection: .Vertical, animated: true)
		collectionView.translatesAutoresizingMaskIntoConstraints = false
	}
}

//MARK: - extension UICollectionViewDelegate and UICollectionViewDataSource
extension PlaylistViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	// MARK: - UICollectionViewDelegate
	
	// MARK: - UICollectionViewDataSource
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 10
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeue(CustomCollectionViewCell.self, forIndexPath: indexPath)
		return cell
	}
}
