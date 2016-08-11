//
//  Playlist.swift
//  ATMusic
//
//  Created by Nguyen Thanh Su on 8/11/16.
//  Copyright © 2016 at. All rights reserved.
//

import Foundation
import RealmSwift

class Playlist: Object {
    dynamic var name: String!
    dynamic var avatar: String?
    var songs = List<Song>()

    convenience init(name: String) {
        self.init()
        self.name = name
    }
}
