//
//  SongListHeader.swift
//  ATMusic
//
//  Created by Nguyen Thanh Su on 8/31/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit

class SongListHeader: UITableViewHeaderFooterView {
    @IBOutlet private weak var nameLabel: UILabel!

    func configHeaderWithName(name: String?) {
        nameLabel.text = "Playlist: " + (name ?? "")
        nameLabel.font = HelveticaFont().Regular(17)
    }

    static func headerHeight() -> CGFloat {
        return 60 * Ratio.width
    }
}
