//
//  Extension.swift
//  ATMusic
//
//  Created by Nguyen Thanh Su on 8/1/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit

extension UIViewController {
    static func loadFromNib() -> Self {
        return self.init(nibName: String(self), bundle: nil)
    }
}

extension UICollectionViewCell {
    static func loadFromNib() -> UINib {
        return UINib(nibName: String(self), bundle: nil)
    }
}
