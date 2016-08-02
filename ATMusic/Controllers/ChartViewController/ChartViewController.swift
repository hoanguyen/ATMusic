//
//  ChartViewController.swift
//  ATMusic
//
//  Created by Nguyen Thanh Su on 8/1/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit
import SwiftUtils

private let kHeightForRow: CGFloat = 60 // height for row

class ChartViewController: UIViewController {
	// MARK: - Private Outlet
	@IBOutlet weak var tableView: UITableView!
	
	// MARK: - private func
	private let cellIdentifier = "cell"
	// fake data
	private var cells = [NSDictionary]()
	
	// MARK: - Override func
	override func viewDidLoad() {
		super.viewDidLoad()
		configView()
		loadData()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	// MARK: - private func
	private func configView() {
		tableView.registerNib(CustomTableViewCell)
		tableView.delegate = self
		tableView.dataSource = self
	}
	
	private func loadData() {
		for i in 0..<10 {
			let cell = NSMutableDictionary()
			cell.setValue("\(i)", forKey: "nameOfSong")
			cell.setValue("\(i)", forKey: "nameOfSinger")
			cell.setValue("\(i)", forKey: "image")
			cell.setValue("\(i)", forKey: "durationOfSong")
			cells.append(cell)
		}
	}
}

//MARK: - extension of UITableViewDelegate and UITableViewDataSource
extension ChartViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return kHeightForRow
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return cells.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeue(CustomTableViewCell)
		let dataCell = cells[indexPath.row]
		cell.loadData(dataCell.objectForKey("image") as? String,
			nameOfSong: dataCell.objectForKey("nameOfSong") as? String,
			nameOfSinger: dataCell.objectForKey("nameOfSinger") as? String,
			durationOfSong: dataCell.objectForKey("durationOfSong") as? String)
		return cell
	}
}
