//
//  Track.swift
//  ATMusic
//
//  Created by Nguyen Thanh Su on 8/8/16.
//  Copyright © 2016 at. All rights reserved.
//

import ObjectMapper

class Song: Mappable {
    private enum Key: String {
        case SongID = "id"
        case Name = "title"
        case Artist = "user.username"
        case Image = "artwork_url"
        case Time = "duration"
    }

    var id: Int?
    var songName: String?
    var singerName: String?
    var urlImage: String?
    var duration: Int?

    required init?(_ map: Map) {

    }

    func mapping(map: Map) {
        id <- map[Key.SongID.rawValue]
        songName <- map[Key.Name.rawValue]
        singerName <- map[Key.Artist.rawValue]
        urlImage <- map[Key.Image.rawValue]
        duration <- map[Key.Time.rawValue]
    }
}
