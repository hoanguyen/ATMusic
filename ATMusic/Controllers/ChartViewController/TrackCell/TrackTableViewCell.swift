//
//  CustomTableViewCell.swift
//  ATMusic
//
//  Created by Nguyen Thanh Su on 8/2/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit
import SDWebImage

private extension Int {
    func convertDuration() -> String {
        let seconds = self / 1000 % 60
        let minutes = (self / 1000 / 60) % 60
        return "\(minutes):" + (seconds < 10 ? "0\(seconds)" : "\(seconds)")
    }
}

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
    func configCellWithTrack(song: Song?) {
        if let imageUrlString = song?.urlImage, imageUrl = NSURL(string: imageUrlString) {
            avatar.sd_setImageWithURL(imageUrl, placeholderImage: UIImage(assetIdentifier: .Placeholder))
        }
        labelNameOfSong.text = song?.songName
        labelNameOfSinger.text = song?.singerName
        labelDurationOfSong.text = song?.duration?.convertDuration()
    }

    // MARK: - static func
    static func cellHeight() -> CGFloat {
        return 70 * Ratio.width
    }

}
