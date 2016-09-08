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
    @IBOutlet private weak var secondContentView: UIView!
    @IBOutlet private weak var moreView: UIView!
    @IBOutlet private weak var mainView: UIView!
    @IBOutlet private weak var moreButton: UIButton!
    // MARK: - public property
    var delegate: TrackTableViewCellDelegate!
    // MARK: - private property
    private var cellIndex = 0
    // MARK: - Override func
    override func awakeFromNib() {
        super.awakeFromNib()
        nameOfSongLabel.font = HelveticaFont().Regular(14)
        nameOfSingerLabel.font = HelveticaFont().Regular(11)
        durationOfSongLabel.font = HelveticaFont().Regular(11)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // MARK: - Private Action
    @IBAction private func didTapButtonMore(sender: UIButton) {
        delegate.didTapMoreButton(self, cellIndex: cellIndex)
    }

    // MARK: - public func
    func configCellWithTrack(song: Song?, index: Int) {
        cellIndex = index
        if let imageUrlString = song?.urlImage, imageUrl = NSURL(string: imageUrlString) {
            avatar.sd_setImageWithURL(imageUrl, placeholderImage: UIImage(assetIdentifier: .Placeholder))
        }
        nameOfSongLabel.text = song?.songName
        nameOfSingerLabel.text = song?.singerName
        durationOfSongLabel.text = song?.duration.convertDuration()
    }

    func configUIColor() {
        backgroundColor = Color.Violet73
        secondContentView.backgroundColor = Color.Violet73
        moreView.backgroundColor = Color.Violet73
        mainView.backgroundColor = Color.Violet73
        moreButton.setBackgroundImage(UIImage(assetIdentifier: .MoreWhite), forState: .Normal)
        moreButton.tintColor = UIColor.whiteColor()
        nameOfSongLabel.textColor = Color.White233
        nameOfSingerLabel.textColor = Color.White178
        durationOfSongLabel.textColor = Color.White178
    }

    // MARK: - static func
    static func cellHeight() -> CGFloat {
        return 70 * Ratio.width
    }

}
