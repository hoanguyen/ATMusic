//
//  SongListCell.swift
//  ATMusic
//
//  Created by Nguyen Thanh Su on 8/30/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit

class SongListCell: UITableViewCell {
    @IBOutlet private weak var songNameLabel: UILabel!
    @IBOutlet private weak var playingButton: UIButton!
    @IBOutlet private weak var indexLabel: UILabel!

    private var index = 0
    private var playing: Bool = false
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func configCellWithname(name: String?, andIndex index: Int, playingAtIndex: Int) {
        self.index = index
        songNameLabel.text = name
        songNameLabel.font = HelveticaFont().Regular(14)
        indexLabel.font = HelveticaFont().Regular(14)
        indexLabel.text = "\(self.index + 1)"
        reloadWithPlayingIndex(playingAtIndex)
    }

    func reloadWithPlayingIndex(index: Int) {
        playing = isPlay(index)
        highlighForCell()
    }

    private func highlighForCell() {
        playingButton.hidden = !playing // show or hide play button
        songNameLabel.textColor = playing ? .redColor() : .whiteColor()
        indexLabel.textColor = playing ? .redColor() : .whiteColor()
    }

    private func isPlay(playingIndex: Int) -> Bool {
        return index == playingIndex ? true : false
    }

    static func cellHeight() -> CGFloat {
        return 44 * Ratio.width
    }
}
