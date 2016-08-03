//
//  CustomCollectionViewCell.swift
//  ATMusic
//
//  Created by Nguyen Thanh Su on 8/2/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit

class PlaylistCell: UICollectionViewCell {
	// MARK: - private property
	@IBOutlet private weak var avatar: UIImageView!
	@IBOutlet private weak var namOfSongLabel: UILabel!
	@IBOutlet private weak var nameOfSingerLabel: UILabel!
	
	// MARK: - override func
	override func awakeFromNib() {
		super.awakeFromNib()
		configUI()
	}
	
	// MARK: - private func
	private func configUI() {
		self.border(color: Color.CollectionCellBorderColor, width: 1)
		layer.masksToBounds = false
		self.shadow(color: Color.CollectionCellBorderColor, offset: CGSize(width: 1, height: 1), opacity: 1, radius: 1)
	}
	
}
