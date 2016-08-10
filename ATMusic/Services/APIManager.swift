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

typealias APIGetTopSongFinished = (result: [Track]) -> Void

enum Router: URLRequestConvertible {
    static let baseURLString = "https://itunes.apple.com/us/rss/"
    static var OAuthToken: String?
    case GetTopSong(limit: Int)

    var method: Alamofire.Method {
        switch self {
        case .GetTopSong:
            return .GET
        }
    }

    var path: String {
        switch self {
        case .GetTopSong(let limit):
            return "topsongs/limit=\(limit)/json"
        }
    }

    // MARK: URLRequestConvertible

    var URLRequest: NSMutableURLRequest {
        let URL = NSURL(string: Router.baseURLString)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod = method.rawValue
        if let token = Router.OAuthToken {
            mutableURLRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        switch self {
        case .GetTopSong(_):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: nil).0
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

    func getTopSong(limit: Int, completionHandler finished: APIGetTopSongFinished) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            Alamofire.request(Router.GetTopSong(limit: limit)).responseJSON { (response) in
                if let JSON = response.result.value {
                    if let feed = JSON["feed"] where ((feed as? Dictionary<String, AnyObject>) != nil) {
                        if let entry = feed?["entry"] {
                            if let tracks = Mapper<Track>().mapArray(entry) {
                                dispatch_async(dispatch_get_main_queue()) {
                                    finished(result: tracks)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
