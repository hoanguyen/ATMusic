//
//  CollectionView.swift
//  ATMusic
//
//  Created by Nguyen Thanh Su on 8/3/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit

extension UICollectionView {
	public func setLayout(collectionSize size: CGSize, numberItemOfRow: Int, scrollDirection: UICollectionViewScrollDirection, animated: Bool) {
		let width = size.width / CGFloat(numberItemOfRow) - (CollectionCellRatio.LayoutMinimumLineSpacing * CGFloat(numberItemOfRow + 1)) / 2
		let height = width * CollectionCellRatio.RectRatioExpect
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .Vertical
		layout.minimumLineSpacing = CollectionCellRatio.LayoutMinimumLineSpacing
		layout.minimumInteritemSpacing = CollectionCellRatio.MinimumInteritemSpacing
		layout.itemSize = CGSize(width: width, height: height)
		layout.sectionInset = CollectionCellRatio.LayoutSectionInset
		self.setCollectionViewLayout(layout, animated: animated)
	}
}
