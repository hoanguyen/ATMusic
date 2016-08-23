//
//  Int.swift
//  ATMusic
//
//  Created by Nguyen Thanh Su on 8/23/16.
//  Copyright © 2016 at. All rights reserved.
//

import Foundation

extension Int {
    func convertToMinute() -> String {
        let seconds = self % 60
        let minutes = (self / 60) % 60
        return "\(minutes):" + (seconds < 10 ? "0\(seconds)" : "\(seconds)")
    }
}
