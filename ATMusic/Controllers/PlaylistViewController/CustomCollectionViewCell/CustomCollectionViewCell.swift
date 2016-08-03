//
//  CustomCollectionViewCell.swift
//  ATMusic
//
//  Created by Nguyen Thanh Su on 8/2/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
	// MARK: - private property
	@IBOutlet private weak var avatar: UIImageView!
	@IBOutlet private weak var labelNameOfSong: UILabel!
	@IBOutlet private weak var labelNameOfSinger: UILabel!
	
	// MARK: - override func
	override func awakeFromNib() {
		super.awakeFromNib()
		configUI()
	}
	
	// MARK: - private func
	private func configUI() {
		// set border for each cell
		self.layer.borderWidth = 1
		self.layer.borderColor = Color.CollectionCellBorderColor
	}
	
}
