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
        case Chart, Playlist, Add, Search, Play30, Search22, HolderPlaylist, Placeholder, Delete, HolderTrack, Shuffle25,
            MoreRed, PlayRed25, PauseRed25,
            ShuffleRed30, ShuffleWhite30,
            PlayWhite60, PauseWhite60, PauseWhite25, MoreWhite, PlayWhite25,
            RepeatAllRed30, RepeatOffWhite30, RepeatOneRed30,
            PlayBlack, PauseBlack, NextBlack, PrevBlack, ListBlack,
            Timer, DownArrowRed30
    }

    convenience init!(assetIdentifier: AssetIdentifier) {
        self.init(named: assetIdentifier.rawValue)
    }

}
