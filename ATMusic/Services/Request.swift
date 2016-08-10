//
//  Request.swift
//  ATMusic
//
//  Created by Nguyen Thanh Su on 8/8/16.
//  Copyright © 2016 at. All rights reserved.
//

import Foundation

enum RequestType: String {
    case GET = "GET"
    case POST = "POST"
}

class Request {
    // singleton
    static let instance = Request()
    func getRequest(method method: RequestType, urlString: String, parameter: Dictionary<String, String>?) -> NSMutableURLRequest? {
        var request: NSMutableURLRequest? = nil
        var nsURL: NSURL?
        switch method {
        case .GET:
            nsURL = NSURL(string: urlString)
        default:
            break
        }
        if let nsURL = nsURL {
            request = NSMutableURLRequest(URL: nsURL, cachePolicy: .UseProtocolCachePolicy, timeoutInterval: 20.0)
        }
        return request
    }
}
