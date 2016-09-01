//
//  TwoImagesCell.swift
//  ATMusic
//
//  Created by Nguyen Thanh Su on 8/16/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit

class TwoImagesCell: BaseCell {
    @IBOutlet private weak var playlistNameLabel: UILabel!
    @IBOutlet private weak var numberSongLabel: UILabel!
    @IBOutlet private weak var imageView1: UIImageView!
    @IBOutlet private weak var imageView2: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        playlistNameLabel.font = HelveticaFont().Regular(14)
        numberSongLabel.font = HelveticaFont().Regular(12)
    }

    func configCell(playlist playlist: Playlist?, index: Int) {
        super.configIndexForCell(index)
        playlistNameLabel.text = playlist?.name
        numberSongLabel.text = "2 songs"
        guard let playlist = playlist else { return }
        if let imageUrlString = playlist.songs[0].urlImage, imageUrl = NSURL(string: imageUrlString) {
            imageView1.sd_setImageWithURL(imageUrl)
        }
        if let imageUrlString = playlist.songs[1].urlImage, imageUrl = NSURL(string: imageUrlString) {
            imageView2.sd_setImageWithURL(imageUrl)
        }
    }
    @IBAction func didTapPlayButton(sender: UIButton) {
        super.didTapPlayButton()
    }

}
