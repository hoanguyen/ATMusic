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
    var songs = List<Song>()

    convenience init(name: String) {
        self.init()
        self.name = name
    }

    func addSong(song: Song) -> Bool {
        for item in songs {
            if item.id == song.id {
                return false
            }
        }
        RealmManager.addSong(song, intoSongList: songs)
        return true
    }

    func deleteSongAtIndex(index: Int) {
        RealmManager.deleteSong(atIndex: index, inSongList: self.songs)
    }

    func setNameWithText(text: String?) -> Bool {
        guard let text = text else { return false }
        RealmManager.updateNameForPlaylist(self, withText: text)
        return true
    }

    class func checkExist(playlistName name: String) -> Bool {
        return RealmManager.getPlaylistWithName(name) == nil ? false : true
    }
}
