//
//  BaseCell.swift
//  ATMusic
//
//  Created by Nguyen Thanh Su on 8/17/16.
//  Copyright © 2016 at. All rights reserved.
//

import Foundation
import UIKit

class BaseCell: UICollectionViewCell {

    private var cellIndex = 0

    func configIndexForCell(index: Int) {
        cellIndex = index
    }

    func didTapPlayButton() {
        NSNotificationCenter.defaultCenter().postNotificationName(Strings.NotificationDetailPlaylist,
            object: nil, userInfo: [Strings.NotiCellIndex: cellIndex])
    }

    static func cellSize() -> CGSize {
        return CGSize(width: Ratio.width * 120, height: Ratio.width * 160)
    }
}
