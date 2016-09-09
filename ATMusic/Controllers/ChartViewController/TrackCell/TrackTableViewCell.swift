//
//  CustomTableViewCell.swift
//  ATMusic
//
//  Created by Nguyen Thanh Su on 8/2/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit
import SDWebImage

private let kRatioCornerRadius = 15 * Ratio.width

protocol TrackTableViewCellDelegate {
    func didTapMoreButton(tableViewCell: TrackTableViewCell, cellIndex: Int)
}

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
    @IBOutlet private weak var nameOfSongLabel: UILabel!
    @IBOutlet private weak var nameOfSingerLabel: UILabel!
    @IBOutlet private weak var durationOfSongLabel: UILabel!
    @IBOutlet private weak var moreView: UIView!
    @IBOutlet private weak var mainView: UIView!
    @IBOutlet private weak var moreButton: UIButton!
    // MARK: - public property
    var delegate: TrackTableViewCellDelegate?
    // MARK: - private property
    private var cellIndex = 0
    // MARK: - Override func
    override func awakeFromNib() {
        super.awakeFromNib()
        nameOfSongLabel.font = HelveticaFont().Regular(17)
        nameOfSingerLabel.font = HelveticaFont().Regular(13)
        durationOfSongLabel.font = HelveticaFont().Regular(13)
        avatar.layer.cornerRadius = kRatioCornerRadius
        avatar.layer.masksToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // MARK: - Private Action
    @IBAction private func didTapButtonMore(sender: UIButton) {
        delegate?.didTapMoreButton(self, cellIndex: cellIndex)
    }

    // MARK: - public func
    func configCellWithTrack(song: Song?, index: Int, showButtonMore: Bool) {
        moreButton.hidden = !showButtonMore
        cellIndex = index
        if let imageUrlString = song?.urlImage, imageUrl = NSURL(string: imageUrlString) {
            avatar.sd_setImageWithURL(imageUrl)
        }
        nameOfSongLabel.text = song?.songName
        nameOfSingerLabel.text = song?.singerName
        durationOfSongLabel.text = song?.duration.convertDuration()
    }

    func changeIndex(index: Int) {
        cellIndex = index
    }

    // MARK: - static func
    static func cellHeight() -> CGFloat {
        return 70 * Ratio.width
    }

}
