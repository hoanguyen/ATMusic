//
//  Track.swift
//  ATMusic
//
//  Created by Nguyen Thanh Su on 8/8/16.
//  Copyright © 2016 at. All rights reserved.
//

import ObjectMapper
import RealmSwift
import Realm

private let numberCharacterNeedToChange = 9 // (large.jpg) have 9 character

class Song: Object, Mappable {
    private enum Key: String {
        case SongID = "id"
        case Name = "title"
        case Artist = "user.username"
        case Image = "artwork_url"
        case Time = "duration"
    }
    dynamic var id = 0
    dynamic var songName: String?
    dynamic var singerName: String?
    dynamic var urlImage: String?
    dynamic var duration = 0

    let owner = LinkingObjects(fromType: Playlist.self, property: "songs")

    override class func primaryKey() -> String? {
        return "id"
    }

    required convenience init?(_ map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        id <- map[Key.SongID.rawValue]
        songName <- map[Key.Name.rawValue]
        singerName <- map[Key.Artist.rawValue]
        urlImage <- map[Key.Image.rawValue]
        changeURLImage()
        duration <- map[Key.Time.rawValue]
    }

    private func changeURLImage() {
        urlImage = urlImage?.stringByReplacingOccurrencesOfString(Strings.LargeString, withString: Strings.ImageSizeForThumbnail)
    }
}
