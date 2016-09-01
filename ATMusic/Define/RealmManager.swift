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

    class func add(object: Object?) {
        do {
            try realm?.write({
                guard let object = object else { return }
                realm?.add(object)
            })
        } catch { }
    }

    class func delete(object: Object?) {
        do {
            try realm?.write({
                guard let object = object else { return }
                realm?.delete(object)
            })
        } catch { }
    }

    class func getAllPlayList() -> Results<Playlist>? {
        let realm = try? Realm()
        return realm?.objects(Playlist)
    }

    class func getLastID<T: Object>(aClass: T.Type) -> T? {
        let objects = realm?.objects(aClass)
        return objects?.last
    }

    class func getFirstItemFree() -> PlaylistName? {
        return realm?.objects(PlaylistName).filter("isUse = false").first
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

    class func changePosition(songs: List<Song>, atFirst firstIndex: Int, withSecond secondIndex: Int) {
        do {
            try realm?.write({
                let songTmp = songs[firstIndex]
                songs[firstIndex] = songs[secondIndex]
                songs[secondIndex] = songTmp
            })
        } catch { }
    }

    class func deleteSong(atIndex index: Int, inSongList songs: List<Song>) {
        do {
            try realm?.write({
                songs.removeAtIndex(index)
            })
        } catch { }
    }

    class func updateNameForPlaylist(playlist: Playlist, withText text: String) {
        do {
            try realm?.write({
                playlist.name = text
            })
        } catch { }
    }

    class func setUsingForItem(object: PlaylistName, isUse: Bool) {
        do {
            try realm?.write({
                object.isUse = isUse
            })
        } catch { }
    }

    class func getItemWithName(name: String) -> PlaylistName? {
        return realm?.objects(PlaylistName).filter("name = %@", name).first
    }
}
