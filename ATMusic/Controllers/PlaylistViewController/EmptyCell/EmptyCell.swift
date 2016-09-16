//
//  AddPlatlistCell.swift
//  ATMusic
//
//  Created by Nguyen Thanh Su on 8/16/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit

class EmptyCell: UICollectionViewCell {
    @IBOutlet private weak var bottomLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        bottomLabel.font = HelveticaFont().Regular(17)
    }

    @IBAction func didTapAddButton(sender: UIButton) {
       kNotification.postNotificationName(Strings.NotiAddPlaylist, object: nil, userInfo: nil)
    }
}
