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
        charVC.title = "Trending"
        let chartNavigation = UINavigationController(rootViewController: charVC)
        chartNavigation.tabBarItem = UITabBarItem(title: "Chart", image: UIImage(assetIdentifier: .Chart), tag: 1)
        // init Search
        let searchVC = SearchViewController.vc()
        searchVC.title = "Search"
        let searchNavigation = UINavigationController(rootViewController: searchVC)
        searchNavigation.tabBarItem = UITabBarItem(title: "Search", image: UIImage(assetIdentifier: .Search), tag: 2)
        // init Playlist
        let playlistVC = PlaylistViewController.vc()
        playlistVC.title = "Playlist"
        let playlistNavigation = UINavigationController(rootViewController: playlistVC)
        playlistNavigation.tabBarItem = UITabBarItem(title: "Playlist", image: UIImage(assetIdentifier: .Playlist), tag: 3)
        tabBar.tintColor = Color.TabBarTinColor
        viewControllers = [chartNavigation, searchNavigation, playlistNavigation]
    }
}
