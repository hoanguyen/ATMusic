//
//  AddPlatlistCell.swift
//  ATMusic
//
//  Created by Nguyen Thanh Su on 8/16/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit

class EmptyCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func didTapAddButton(sender: UIButton) {
        NSNotificationCenter.defaultCenter().postNotificationName(Strings.NotiAddPlaylist, object: nil, userInfo: nil)
    }
}
