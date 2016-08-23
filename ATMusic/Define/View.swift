//
//  View.swift
//  ATMusic
//
//  Created by Nguyen Thanh Su on 8/22/16.
//  Copyright © 2016 at. All rights reserved.
//

import Foundation
import UIKit

class View {
    static func createPlayerBlurView() -> UIView {
        let blurView = UIView(frame: PlayerViewController.playerViewFrame())
        let blurEffect = UIBlurEffect(style: .Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = blurView.bounds
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight] // for supporting device rotation
        blurView.addSubview(blurEffectView)
        return blurView
    }
}
