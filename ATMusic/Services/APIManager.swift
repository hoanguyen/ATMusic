//
//  APIService.swift
//  ATMusic
//
//  Created by Nguyen Thanh Su on 8/8/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

typealias APIFinished = (result: [Song]?, error: Bool, message: String?) -> Void

private enum MusicKind: String {
    case TOP = "top"
    case TRENDING = "trending"
}

private enum MusicGenre: String {
    case All = "soundcloud:genres:all-music"
    case Classical = "soundcloud:genres:classical"
    // maybe put in here more genre
}

enum Router: URLRequestConvertible {
    static var OAuthToken: String?
    case GetTopSong(limit: Int, offset: Int)
    case Search(key: String, limit: Int, offset: Int)

    var method: Alamofire.Method {
        switch self {
        case .GetTopSong:
            return .GET
        case .Search:
            return .GET
        }
    }

    var path: String {
        switch self {
        case .GetTopSong:
            return "/charts"
        case .Search:
            return "/search"
        }
    }

    var parameter: [String: AnyObject] {
        var parameters = [String: AnyObject]()
        parameters["client_id"] = Strings.ClientID
        switch self {
        case .GetTopSong(let limit, let offset):
            parameters["kind"] = MusicKind.TOP.rawValue
            parameters["genre"] = MusicGenre.All.rawValue
            parameters["limit"] = limit
            parameters["offset"] = offset
            return parameters
        case .Search(let key, let limit, let offset):
            parameters["q"] = key
            parameters["limit"] = limit
            parameters["offset"] = offset
            return parameters
        }
    }

    // MARK: URLRequestConvertible

    var URLRequest: NSMutableURLRequest {
        let URL = NSURL(string: Strings.BaseURLString)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod = method.rawValue
        switch self {
        case .GetTopSong:
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameter).0
        case .Search:
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameter).0
        }
    }
}

class APIManager {
    class var sharedInstance: APIManager {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: APIManager? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = APIManager()
        }
        return Static.instance!
    }

    func getTopSong(withlimit limit: Int, atOffset offset: Int, completionHandler finished: APIFinished) {
        Alamofire.request(Router.GetTopSong(limit: limit, offset: offset)).responseJSON { (response) in
            switch response.result {
            case .Success:
                guard let JSON = response.result.value else { finished(result: nil,
                    error: true, message: response.result.debugDescription) ; return }
                let collection = JSON["collection"] as? NSArray
                var songs = [Song]()
                if let collection = collection {
                    for item in collection {
                        let track = item["track"]
                        guard let song = Mapper<Song>().map(track) else { break }
                        songs.append(song)
                    }
                }
                finished(result: songs, error: false, message: nil)
            case .Failure:
                finished(result: nil, error: true, message: nil)
            }
        }
    }

    func searchSong(withKey key: String, limit: Int, atOffet offset: Int, completionHandler finished: APIFinished) {
        Alamofire.request(Router.Search(key: key, limit: limit, offset: offset)).responseJSON { (response) in
            switch response.result {
            case .Success:
                guard let JSON = response.result.value else { finished(result: nil,
                    error: true, message: response.result.debugDescription) ; return }
                let collection = JSON["collection"] as? NSArray
                var songs = [Song]()
                if let collection = collection {
                    for item in collection {
                        guard let song = Mapper<Song>().map(item) else { break }
                        guard let _ = song.songName else { continue }
                        if song.urlImage == nil {
                            if let user = item["user"] as? Dictionary<String, AnyObject> {
                                if let avatar = user["avatar_url"] as? String {
                                    song.urlImage = avatar
                                }
                            }
                        }
                        songs.append(song)
                    }
                }
                finished(result: songs, error: false, message: nil)
            case .Failure:
                finished(result: nil, error: true, message: nil)
        } }
    }

    func cancel() {
        Manager.sharedInstance.session.getAllTasksWithCompletionHandler { (tasks) -> Void in
            tasks.forEach({ $0.cancel() })
        }
    }
}