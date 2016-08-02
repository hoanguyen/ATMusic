//
//  CustomTableViewCell.swift
//  ATMusic
//
//  Created by Nguyen Thanh Su on 8/2/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
	// MARK: - private Outlets
	@IBOutlet private weak var avatar: UIImageView!
	@IBOutlet private weak var labelNameOfSong: UILabel!
	@IBOutlet private weak var labelNameOfSinger: UILabel!
	@IBOutlet private weak var labelDurationOfSong: UILabel!
	
	// MARK: - Override func
	override func awakeFromNib() {
		super.awakeFromNib()
	}
	
	override func setSelected(selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
	}
	
	// MARK: - Private Action
	@IBAction private func didTapButtonMore(sender: UIButton) {
		
	}
	
	// MARK:-public func
	func loadData(image: String?, nameOfSong: String?, nameOfSinger: String?, durationOfSong: String?) {
		avatar.image = UIImage(named: image ?? "")
		labelNameOfSong.text = nameOfSong ?? "1"
		labelNameOfSinger.text = nameOfSinger ?? "2"
		labelDurationOfSong.text = durationOfSong ?? "3"
	}
}
