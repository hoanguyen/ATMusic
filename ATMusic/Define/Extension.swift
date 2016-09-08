//
//  Extension.swift
//  ATMusic
//
//  Created by Nguyen Thanh Su on 8/3/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit
import SwiftUtils
import SystemConfiguration

struct Ratio {
    static let width: CGFloat = kScreenSize.width / DeviceType.Phone6.size.width
}

struct Number {
    static let kDurationToRotate = 20.0
}

class Helper {
    class func delay(second second: Int, completion: () -> Void) {
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            completion()
        }

    }

    class func checkingPlayList(string: String?) -> Bool {
        if let string = string {
            do {
                let regex = try NSRegularExpression(pattern: Strings.paternMatchString, options: .CaseInsensitive)
                let range = NSRange(location: 0, length: string.characters.count)
                let matches = regex.matchesInString(string, options: [], range: range)
                return matches.count > 0
            } catch { }
        }
        return false
    }

    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }

}

enum SoundCloudKind: Int {
    case Top
    case Trending

    var path: String {
        switch self {
        case .Top:
            return "top"
        case .Trending:
            return "trending"
        }
    }
}

enum GenreType: Int {
    case All
    case Music
    case Audio

    var numberOfItem: Int {
        switch self {
        case .All:
            return 2
        case .Music:
            return 30
        case .Audio:
            return 11
        }
    }

    var title: String {
        switch self {
        case .All:
            return "All"
        case .Music:
            return "Music"
        case .Audio:
            return "Audio"
        }
    }
}

enum SoundCloudMusic: Int {
    case AlternativeRock
    case Ambient
    case Classical
    case Country
    case DanceEDM
    case Dancehall
    case DeepHouse
    case Disco
    case DrumBass
    case Dubstep
    case Electronic
    case FolkSingerSongWriter
    case HiphopRap
    case House
    case Indie
    case JazzBlues
    case Latin
    case Metal
    case Piano
    case Pop
    case RBSoul
    case Reggae
    case Reggaeton
    case Rock
    case SoundTrack
    case Techno
    case Trance
    case Trap
    case Triphop
    case World

    var itemName: String {
        switch self {
        case .AlternativeRock:
            return "Alternative Rock"
        case .Ambient:
            return "Ambient"
        case .Classical:
            return "Classical"
        case .Country:
            return "Country"
        case .DanceEDM:
            return "Dance & EDM"
        case .Dancehall:
            return "Dancehall"
        case .DeepHouse:
            return "Deep House"
        case .Disco:
            return "Disco"
        case .DrumBass:
            return "Drum & Bass"
        case .Dubstep:
            return "Dubstep"
        case .Electronic:
            return "Electronic"
        case .FolkSingerSongWriter:
            return "Folk & Singer-Songwriter"
        case .HiphopRap:
            return "Hiphop & Rap"
        case .House:
            return "House"
        case .Indie:
            return "Indie"
        case .JazzBlues:
            return "Jazz & Blues"
        case .Latin:
            return "Latin"
        case .Metal:
            return "Metal"
        case .Piano:
            return "Piano"
        case .Pop:
            return "Pop"
        case .RBSoul:
            return "R&B & Soul"
        case .Reggae:
            return "Reggae"
        case .Reggaeton:
            return "Reggaeton"
        case .Rock:
            return "Rock"
        case .SoundTrack:
            return "Soundtrack"
        case .Techno:
            return "Techno"
        case .Trance:
            return "Trance"
        case .Trap:
            return "Trap"
        case .Triphop:
            return "Triphop"
        case .World:
            return "World"
        }
    }

    var path: String {
        switch self {
        case .AlternativeRock:
            return "soundcloud:genres:alternativerock"
        case .Ambient:
            return "soundcloud:genres:ambient"
        case .Classical:
            return "soundcloud:genres:classical"
        case .Country:
            return "soundcloud:genres:country"
        case .DanceEDM:
            return "soundcloud:genres:danceedm"
        case .Dancehall:
            return "soundcloud:genres:dancehall"
        case .DeepHouse:
            return "soundcloud:genres:deephouse"
        case .Disco:
            return "soundcloud:genres:disco"
        case .DrumBass:
            return "soundcloud:genres:drumbass"
        case .Dubstep:
            return "soundcloud:genres:dubstep"
        case .Electronic:
            return "soundcloud:genres:electronic"
        case .FolkSingerSongWriter:
            return "soundcloud:genres:folksingersongwriter"
        case .HiphopRap:
            return "soundcloud:genres:hiphoprap"
        case .House:
            return "soundcloud:genres:house"
        case .Indie:
            return "soundcloud:genres:indie"
        case .JazzBlues:
            return "soundcloud:genres:jazzblues"
        case .Latin:
            return "soundcloud:genres:latin"
        case .Metal:
            return "soundcloud:genres:metal"
        case .Piano:
            return "soundcloud:genres:piano"
        case .Pop:
            return "soundcloud:genres:pop"
        case .RBSoul:
            return "soundcloud:genres:rbsoul"
        case .Reggae:
            return "soundcloud:genres:reggae"
        case .Reggaeton:
            return "soundcloud:genres:reggaeton"
        case .Rock:
            return "soundcloud:genres:rock"
        case .SoundTrack:
            return "soundcloud:genres:soundtrack"
        case .Techno:
            return "soundcloud:genres:techno"
        case .Trance:
            return "soundcloud:genres:trance"
        case .Trap:
            return "soundcloud:genres:trap"
        case .Triphop:
            return "soundcloud:genres:triphop"
        case .World:
            return "soundcloud:genres:world"
        }
    }
}

enum SoundCloudAudio: Int {
    case AudioBooks
    case Business
    case Comedy
    case Entertainment
    case Learning
    case NewSpolitics
    case ReligionSpiritualty
    case Science
    case Sports
    case StoryTelling
    case Technology

    var itemName: String {
        switch self {
        case .AudioBooks:
            return "AudioBooks"
        case .Business:
            return "Business"
        case .Comedy:
            return "Comedy"
        case .Entertainment:
            return "Entertainment"
        case .Learning:
            return "Learning"
        case .NewSpolitics:
            return "New & Spolitics"
        case .ReligionSpiritualty:
            return "Religion & Spiritualty"
        case .Science:
            return "Science"
        case .Sports:
            return "Sports"
        case .StoryTelling:
            return "Storytelling"
        case .Technology:
            return "Technology"
        }
    }

    var path: String {
        switch self {
        case .AudioBooks:
            return "soundcloud:genres:audiobooks"
        case .Business:
            return "soundcloud:genres:business"
        case .Comedy:
            return "soundcloud:genres:comedy"
        case .Entertainment:
            return "soundcloud:genres:entertainment"
        case .Learning:
            return "soundcloud:genres:learning"
        case .NewSpolitics:
            return "soundcloud:genres:newspolitics"
        case .ReligionSpiritualty:
            return "soundcloud:genres:religionspirituality"
        case .Science:
            return "soundcloud:genres:science"
        case .Sports:
            return "soundcloud:genres:sports"
        case .StoryTelling:
            return "soundcloud:genres:storytelling"
        case .Technology:
            return "soundcloud:genres:technology"
        }
    }
}

enum SoundCloudGenreAll: Int {
    case AllMusic
    case AllAudio

    var itemName: String {
        switch self {
        case .AllMusic:
            return "All music"
        case .AllAudio:
            return "All audio"
        }
    }

    var path: String {
        switch self {
        case .AllMusic:
            return "soundcloud:genres:all-music"
        case .AllAudio:
            return "soundcloud:genres:all-audio"
        }
    }

}
