//
//  AppDelegate.swift
//  ATMusic
//
//  Created by Nguyen Thanh Su on 8/1/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit

let kAppDelegate = UIApplication.sharedApplication().delegate as? AppDelegate

enum RepeatType {
    case None
    case One
    case All
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var detailPlayerVC: DetailPlayerViewController?
    var repeating: RepeatType = .None
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = BaseTabBarController()
        detailPlayerVC = DetailPlayerViewController(song: nil, songIndex: -1) // null init
        window?.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        print("applicationWillResignActive")
    }

    func applicationDidEnterBackground(application: UIApplication) {
        print("background")
//        detailPlayerVC?.player?.play()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        print("applicationWillEnterForeground")
    }

    func applicationDidBecomeActive(application: UIApplication) {
        print("applicationDidBecomeActive")
    }

    func applicationWillTerminate(application: UIApplication) {
        print("applicationWillTerminate")
    }
}
