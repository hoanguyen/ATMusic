//
//  Extension.swift
//  ATMusic
//
//  Created by Nguyen Thanh Su on 8/3/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit
import SwiftUtils

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
}
