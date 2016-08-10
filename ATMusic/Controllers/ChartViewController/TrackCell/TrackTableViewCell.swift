//
//  CustomTableViewCell.swift
//  ATMusic
//
//  Created by Nguyen Thanh Su on 8/2/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit
import SDWebImage

class TrackTableViewCell: UITableViewCell {
    // MARK: - private Outlets
    @IBOutlet private weak var avatar: UIImageView!
    @IBOutlet private weak var labelNameOfSong: UILabel!
    @IBOutlet private weak var labelNameOfSinger: UILabel!
    @IBOutlet private weak var labelDurationOfSong: UILabel!

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

    }

    // MARK: - public func
    func configCellWithTrack(track: Track) {
        if let imageUrlString = track.urlImage, imageUrl = NSURL(string: imageUrlString) {
            print(imageUrlString)
            avatar.sd_setImageWithURL(imageUrl, placeholderImage: UIImage(assetIdentifier: .Placeholder))
        }
        labelNameOfSong.text = track.songName
        labelNameOfSinger.text = track.singerName
        if let duration = track.duration {
            if let durationInMS = Int(duration) { // convert to Int value
                let durationInS = durationInMS / 10000 // from milisecond to second
                let seconds = durationInS % 60
                let hours = (durationInS / 60) % 60
                labelDurationOfSong.text = "\(hours):\(seconds)"
            }
        }

    }
// MARK: - static func
    static func cellHeight() -> CGFloat {
        return 70 * Ratio.width
    }
}
