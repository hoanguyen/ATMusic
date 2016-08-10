//
//  Track.swift
//  ATMusic
//
//  Created by Nguyen Thanh Su on 8/8/16.
//  Copyright © 2016 at. All rights reserved.
//

import ObjectMapper

class Track: Mappable {
    private enum Key: String {
        case TrackID = "id.attributes.im:id"
        case Name = "im:name.label"
        case Artist = "im:artist.label"
        case Image = "im:image.2.label"
        case Time = "link.1.im:duration.label"
    }

    var id: String?
    var songName: String?
    var singerName: String?
    var urlImage: String?
    var duration: String?

    required init?(_ map: Map) {

    }

    func mapping(map: Map) {
        id <- map[Key.TrackID.rawValue]
        songName <- map[Key.Name.rawValue]
        singerName <- map[Key.Artist.rawValue]
        urlImage <- map[Key.Image.rawValue]
        duration <- map[Key.Time.rawValue]
    }

//    static func setImage(urlImage: String?) -> UIImage? {
//        if let image = kAppDelegate?.kCache.objectForKey(urlImage) as? NSData {
//            return UIImage(data: image)
//        } else {
//
//        }
//    }
}
