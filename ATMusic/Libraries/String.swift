//
//  String.swift
//  ATMusic
//
//  Created by Nguyen Thanh Su on 8/12/16.
//  Copyright © 2016 at. All rights reserved.
//

import Foundation

extension String {
    func concat(text: String?) -> String {
        guard let text = text else { return self }
        return "\(self)\n \(text)"
    }
}
