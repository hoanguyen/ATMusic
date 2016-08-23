//
//  Image.swift
//  ATMusic
//
//  Created by Nguyen Thanh Su on 8/2/16.
//  Copyright © 2016 at. All rights reserved.
//
import UIKit

extension UIImage {
    enum AssetIdentifier: String {
        case Chart, Playlist, Add, Search, Play30, PlayRed25, PauseRed25, PauseWhite25, PlayWhite25, Search22,
            Shuffle25, MoreRed, MoreWhite, Delete, HolderTrack, HolderPlaylist, Placeholder,
            PlayWhite60, PauseWhite60
    }

    convenience init!(assetIdentifier: AssetIdentifier) {
        self.init(named: assetIdentifier.rawValue)
    }

}
