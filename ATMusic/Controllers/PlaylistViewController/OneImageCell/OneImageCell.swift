//
//  OneImageCell.swift
//  ATMusic
//
//  Created by Nguyen Thanh Su on 8/16/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit

class OneImageCell: BaseCell {
    // MARK: - private oulet
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var playlistNameLabel: UILabel!
    @IBOutlet private weak var numberSongLabel: UILabel!

    // MARK: - private property
//    private let cellIndex = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        playlistNameLabel.font = HelveticaFont().Regular(12)
        playlistNameLabel.font = HelveticaFont().Regular(11)
    }

    func configCell(playlist playlist: Playlist?, index: Int) {
        super.configIndexForCell(index)
        playlistNameLabel.text = playlist?.name
        if playlist?.songs.count == 0 {
            imageView.image = UIImage(assetIdentifier: .HolderPlaylist)
            numberSongLabel.text = Strings.ZeroSong
        } else {
            if let imageUrlString = playlist?.songs.first?.urlImage, imageUrl = NSURL(string: imageUrlString) {
                imageView.sd_setImageWithURL(imageUrl, placeholderImage: UIImage(assetIdentifier: .Placeholder))
                numberSongLabel.text = Strings.OneSong
            }
        }
    }

    @IBAction func didTapPlayButton(sender: UIButton) {
        super.didTapPlayButton()
    }

}
