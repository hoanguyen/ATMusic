//
//  UIView.swift
//  ATMusic
//
//  Created by Nguyen Thanh Su on 8/22/16.
//  Copyright © 2016 at. All rights reserved.
//

import Foundation
import UIKit

private let kRotationAnimationKey = "com.myapplication.rotationanimationkey"

extension UIView {
    func rotateView(startValue fromValue: CGFloat, duration: Double = 1.0) {
        if self.layer.animationForKey(kRotationAnimationKey) == nil {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
            rotationAnimation.fromValue = fromValue
            rotationAnimation.toValue = CGFloat(M_PI * 2.0) + fromValue
            rotationAnimation.duration = duration
            rotationAnimation.repeatCount = Float.infinity
            self.layer.addAnimation(rotationAnimation, forKey: kRotationAnimationKey)
        }
    }

    func stopRotateView() -> CGFloat? {
        var currentAngleFloat: CGFloat?
        if let currentLayer = self.layer.presentationLayer() as? CALayer {
            if let currentAngle = currentLayer.valueForKeyPath("transform.rotation.z") as? CGFloat {
                currentAngleFloat = currentAngle
                self.transform = CGAffineTransformMakeRotation(currentAngle)
            }
        }
        self.layer.removeAnimationForKey(kRotationAnimationKey)
        return currentAngleFloat
    }
}
