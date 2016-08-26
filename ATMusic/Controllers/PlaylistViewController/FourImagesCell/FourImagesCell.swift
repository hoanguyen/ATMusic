//
//  CustomCollectionViewCell.swift
//  ATMusic
//
//  Created by Nguyen Thanh Su on 8/2/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit
import SDWebImage

private extension CGFloat {
    static let topMargin = 0 * Ratio.width
    static let leftMargin = 0 * Ratio.width
    static let bottomMargin = 0 * Ratio.width
    static let rightMargin = 0 * Ratio.width
}

class FourImagesCell: BaseCell {
    // MARK: - private outlet
    @IBOutlet private weak var playlistNameLabel: UILabel!
    @IBOutlet private weak var numberSongLabel: UILabel!
    @IBOutlet private weak var imageView1: UIImageView!
    @IBOutlet private weak var imageView2: UIImageView!
    @IBOutlet private weak var imageView3: UIImageView!
    @IBOutlet private weak var imageView4: UIImageView!

    // MARK: - override func
    override func awakeFromNib() {
        super.awakeFromNib()
        playlistNameLabel.font = HelveticaFont().Regular(14)
        numberSongLabel.font = HelveticaFont().Regular(12)
    }

    // MARK: - public func
    func configCell(playlist playlist: Playlist?, index: Int) {
        super.configIndexForCell(index)
        playlistNameLabel.text = playlist?.name
        if let songs = playlist?.songs {
            numberSongLabel.text = "\(songs.count) songs"
        }
        if let imageUrlString = playlist?.songs[0].urlImage, imageUrl = NSURL(string: imageUrlString) {
            imageView1.sd_setImageWithURL(imageUrl, placeholderImage: UIImage(assetIdentifier: .Placeholder))
        }
        if let imageUrlString = playlist?.songs[1].urlImage, imageUrl = NSURL(string: imageUrlString) {
            imageView2.sd_setImageWithURL(imageUrl, placeholderImage: UIImage(assetIdentifier: .Placeholder))
        }
        if let imageUrlString = playlist?.songs[2].urlImage, imageUrl = NSURL(string: imageUrlString) {
            imageView3.sd_setImageWithURL(imageUrl, placeholderImage: UIImage(assetIdentifier: .Placeholder))
        }
        if let imageUrlString = playlist?.songs[3].urlImage, imageUrl = NSURL(string: imageUrlString) {
            imageView4.sd_setImageWithURL(imageUrl, placeholderImage: UIImage(assetIdentifier: .Placeholder))
        }
    }

    @IBAction func didTapPlayButton(sender: UIButton) {
        super.didTapPlayButton()
    }
}
