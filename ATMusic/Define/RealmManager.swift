//
//  RealmManager.swift
//  ATMusic
//
//  Created by Nguyen Thanh Su on 8/8/16.
//  Copyright © 2016 at. All rights reserved.
//

import RealmSwift

class RealmManager {

    static let realm = try? Realm()

    class func add(object: Object) {
        do {
            try realm?.write({
                realm?.add(object)
            })
        } catch { }
    }

    class func delete(object: Object) {
        do {
            try realm?.write({
                realm?.delete(object)
            })
        } catch { }
    }

    class func getAllPlayList() -> Results<Playlist>? {
        return realm?.objects(Playlist)
    }

    class func addSong(song: Song, intoSongList songs: List<Song>) {
        var tempSong = song // a temporary song to check that exists in db
        if let object = realm?.objects(Song).filter("id = %@", song.id).first { // check exist
            tempSong = object
        }
        do {
            try realm?.write({
                songs.append(tempSong)
            })
        } catch { }
    }
}
