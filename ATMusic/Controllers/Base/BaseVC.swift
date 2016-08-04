//
//  BaseVC.swift
//  ATMusic
//
//  Created by Nguyen Thanh Su on 8/4/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit
import SwiftUtils

class BaseVC: ViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		loadData()
		configUI()
	}
	func loadData() { }
	func configUI() { }
	
}
