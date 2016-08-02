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
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configTabBar()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	// Mark: - config Tabbar func
	private func configTabBar() {
		// init Chart
		let charVC = ChartViewController.vc()
		charVC.title = "Trending"
		let chartNavigation = UINavigationController(rootViewController: charVC)
		chartNavigation.tabBarItem = UITabBarItem(title: "Chart", image: UIImage(named: "home"), tag: 1)
		
		// init Search
		let searchVC = SearchViewController.vc()
		searchVC.title = "Search"
		let searchNavigation = UINavigationController(rootViewController: searchVC)
		searchNavigation.tabBarItem = UITabBarItem(title: "Search", image: UIImage(named: "star"), tag: 2)
		
		// init Playlist
		let playlistVC = PlaylistViewController.vc()
		playlistVC.title = "Playlist"
		let playlistNavigation = UINavigationController(rootViewController: playlistVC)
		playlistNavigation.tabBarItem = UITabBarItem(title: "Playlist", image: UIImage(named: "placeholder"), tag: 3)
		
		viewControllers = [chartNavigation, searchNavigation, playlistNavigation]
	}
}
