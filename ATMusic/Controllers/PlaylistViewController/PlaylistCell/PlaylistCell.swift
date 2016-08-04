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
        layer.masksToBounds = false
        shadow(color: UIColor.blackColor(), offset: CGSize(width: 0, height: 1), opacity: 0.5, radius: 1)
        namOfSongLabel.font = HelveticaFont().Regular(14)
        nameOfSingerLabel.font = HelveticaFont().Regular(11)
    }

    // MARK: - static func
    static func cellSize() -> CGSize {
        return CGSize(width: Ratio.width * 160, height: Ratio.width * 217)
    }

    func configData(index index: Int) {
        namOfSongLabel.text = "Sing me to sleep \(index)"
    }

}
