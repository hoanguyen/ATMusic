//
//  CustomTableViewCell.swift
//  ATMusic
//
//  Created by Nguyen Thanh Su on 8/2/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit
import SDWebImage

protocol TrackTableViewCellDelegate {
    func didTapMoreButton(tableViewCell: TrackTableViewCell, cellIndex: Int)
}

class TrackTableViewCell: UITableViewCell {
    // MARK: - private Outlets
    @IBOutlet private weak var avatar: UIImageView!
    @IBOutlet private weak var labelNameOfSong: UILabel!
    @IBOutlet private weak var labelNameOfSinger: UILabel!
    @IBOutlet private weak var labelDurationOfSong: UILabel!
    // MARK: - public property
    var delegate: TrackTableViewCellDelegate!
    // MARK: - private property
    private var cellIndex = 0
    // MARK: - Override func
    override func awakeFromNib() {
        super.awakeFromNib()
        labelNameOfSong.font = HelveticaFont().Regular(14)
        labelNameOfSinger.font = HelveticaFont().Regular(11)
        labelDurationOfSong.font = HelveticaFont().Regular(11)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // MARK: - Private Action
    @IBAction private func didTapButtonMore(sender: UIButton) {
        delegate.didTapMoreButton(self, cellIndex: cellIndex)
    }

    // MARK: - public func
    func configCellWithTrack(song: Song, index: Int) {
        cellIndex = index
        if let imageUrlString = song.urlImage, imageUrl = NSURL(string: imageUrlString) {
            avatar.sd_setImageWithURL(imageUrl, placeholderImage: UIImage(assetIdentifier: .Placeholder))
        }
        labelNameOfSong.text = song.songName
        labelNameOfSinger.text = song.singerName
//        if let duration = song.duration {
        let durationInS = song.duration / 1000 // from milisecond to second
        let seconds = durationInS % 60
        let minutes = (durationInS / 60) % 60
        labelDurationOfSong.text = "\(minutes):" + (seconds < 10 ? "0\(seconds)" : "\(seconds)")
//        }
    }
// MARK: - static func
    static func cellHeight() -> CGFloat {
        return 70 * Ratio.width
    }
}
