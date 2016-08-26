//
//  ThreeImagesCell.swift
//  ATMusic
//
//  Created by Nguyen Thanh Su on 8/16/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit

class ThreeImagesCell: BaseCell {
    @IBOutlet private weak var playlistNameLabel: UILabel!
    @IBOutlet private weak var numberSongLabel: UILabel!
    @IBOutlet private weak var imageView1: UIImageView!
    @IBOutlet private weak var imageView2: UIImageView!
    @IBOutlet private weak var imageView3: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        playlistNameLabel.font = HelveticaFont().Regular(12)
        playlistNameLabel.font = HelveticaFont().Regular(11)
    }

    func configCell(playlist playlist: Playlist?, index: Int) {
        super.configIndexForCell(index)
        playlistNameLabel.text = playlist?.name
        if let countSong = playlist?.songs.count {
            numberSongLabel.text = "\(countSong)" + Strings.Songs
        }
        guard let playlist = playlist else { return }
        if let imageUrlString = playlist.songs[0].urlImage, imageUrl = NSURL(string: imageUrlString) {
            imageView1.sd_setImageWithURL(imageUrl, placeholderImage: UIImage(assetIdentifier: .Placeholder))
        }
        if let imageUrlString = playlist.songs[1].urlImage, imageUrl = NSURL(string: imageUrlString) {
            imageView2.sd_setImageWithURL(imageUrl, placeholderImage: UIImage(assetIdentifier: .Placeholder))
        }
        if let imageUrlString = playlist.songs[2].urlImage, imageUrl = NSURL(string: imageUrlString) {
            imageView3.sd_setImageWithURL(imageUrl, placeholderImage: UIImage(assetIdentifier: .Placeholder))
        }
    }

    @IBAction func didTapPlayButton(sender: UIButton) {
        super.didTapPlayButton()
    }
}
