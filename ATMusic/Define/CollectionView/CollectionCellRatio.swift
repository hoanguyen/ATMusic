//
//  CollectionCellRatio.swift
//  ATMusic
//
//  Created by Nguyen Thanh Su on 8/3/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit

class CollectionCellRatio {
	static let WidthExpect: CGFloat = 20
	static let HeightExpect: CGFloat = 15
	static let RectRatioExpect: CGFloat = WidthExpect / HeightExpect // Rectangle ratio in width length divide height length
	static let LayoutMinimumLineSpacing: CGFloat = 20
	static let MinimumInteritemSpacing: CGFloat = 20
	static let LayoutSectionInset: UIEdgeInsets = UIEdgeInsets(top: LayoutMinimumLineSpacing,
		left: LayoutMinimumLineSpacing,
		bottom: LayoutMinimumLineSpacing,
		right: LayoutMinimumLineSpacing)
}
