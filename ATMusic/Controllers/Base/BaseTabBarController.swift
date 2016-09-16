//
//  BaseTabBarController.swift
//  ATMusic
//
//  Created by Nguyen Thanh Su on 8/1/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit
import SwiftUtils

class BaseTabBarController: UITabBarController {

    // MARK: Override func
    override func viewDidLoad() {
        super.viewDidLoad()
        configTabBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - config Tabbar func
    private func configTabBar() {
        // init Chart
        let charVC = ChartViewController.vc()
        charVC.title = Strings.Trending
        let chartNavigation = UINavigationController(rootViewController: charVC)
        chartNavigation.tabBarItem = UITabBarItem(title: Strings.Chart, image: UIImage(assetIdentifier: .Chart), tag: 1)
        // init Search
        let searchVC = SearchViewController.vc()
        searchVC.title = Strings.Search
        let searchNavigation = UINavigationController(rootViewController: searchVC)
        searchNavigation.tabBarItem = UITabBarItem(title: Strings.Search, image: UIImage(assetIdentifier: .Search), tag: 2)
        // init Playlist
        let playlistVC = PlaylistViewController.vc()
        playlistVC.title = Strings.Playlist
        let playlistNavigation = UINavigationController(rootViewController: playlistVC)
        playlistNavigation.tabBarItem = UITabBarItem(title: Strings.Playlist, image: UIImage(assetIdentifier: .Playlist), tag: 3)
        tabBar.tintColor = Color.TabBarTinColor
        viewControllers = [chartNavigation, searchNavigation, playlistNavigation]
    }
}
