//
//  UIView.swift
//  ATMusic
//
//  Created by Nguyen Thanh Su on 8/22/16.
//  Copyright © 2016 at. All rights reserved.
//

import Foundation
import UIKit

private var startValue: CGFloat = 0.0

extension UIView {
    func rotateView(duration: Double = 1.0) {
        let kRotationAnimationKey = "com.myapplication.rotationanimationkey" // Any key
        if self.layer.animationForKey(kRotationAnimationKey) == nil {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
            rotationAnimation.fromValue = startValue
            rotationAnimation.toValue = CGFloat(M_PI * 2.0) + startValue
            rotationAnimation.duration = duration
            rotationAnimation.repeatCount = Float.infinity
            self.layer.addAnimation(rotationAnimation, forKey: kRotationAnimationKey)
            startValue = 0.0
        }
    }

    func stopRotateView() {
        let kRotationAnimationKey = "com.myapplication.rotationanimationkey"
        if let currentLayer = self.layer.presentationLayer() as? CALayer {
            if let currentAngle = currentLayer.valueForKeyPath("transform.rotation.z") as? CGFloat {
                startValue = currentAngle
                self.transform = CGAffineTransformMakeRotation(currentAngle)
            }
        }
        self.layer.removeAnimationForKey(kRotationAnimationKey)
    }
}
