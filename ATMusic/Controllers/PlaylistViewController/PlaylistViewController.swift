//
//  PlaylistViewController.swift
//  ATMusic
//
//  Created by Nguyen Thanh Su on 8/1/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit
import SwiftUtils

private extension CGFloat {
	static let collectionViewMarginTop = 12 * Ratio.width
	static let collectionViewMarginLeft = 18 * Ratio.width
	static let collectionViewMarginBottom = 13 * Ratio.width
	static let collectionViewMarginRight = 18 * Ratio.width
}

private extension UIEdgeInsets {
	static func insetForCollectionView() -> UIEdgeInsets {
		return UIEdgeInsets(top: CGFloat.collectionViewMarginTop,
			left: CGFloat.collectionViewMarginLeft,
			bottom: CGFloat.collectionViewMarginBottom,
			right: CGFloat.collectionViewMarginRight)
	}
}

class PlaylistViewController: ViewController {
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
		// register nib for cell, using library
		collectionView.registerNib(PlaylistCell)
		// delegate and datasource for collectionview
		collectionView.delegate = self
		collectionView.dataSource = self
		// set translucent for tabbar and navigationbar
		navigationController?.navigationBar.translucent = false
		tabBarController?.tabBar.translucent = false
		collectionView.backgroundColor = UIColor.clearColor()
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
		let cell = collectionView.dequeue(PlaylistCell.self, forIndexPath: indexPath)
		return cell
	}
}

extension PlaylistViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
			return PlaylistCell.cellSize()
	}
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
		insetForSectionAtIndex section: Int) -> UIEdgeInsets {
			return .insetForCollectionView()
	}
}
