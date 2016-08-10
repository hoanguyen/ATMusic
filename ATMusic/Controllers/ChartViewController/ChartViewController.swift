//
//  ChartViewController.swift
//  ATMusic
//
//  Created by Nguyen Thanh Su on 8/1/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit
import SwiftUtils
import RealmSwift
import Alamofire
import ObjectMapper
import SVPullToRefresh

class ChartViewController: BaseVC {
    // MARK: - Private Outlet
    @IBOutlet private weak var tableView: UITableView!
    private var limit = 10
    private var tracks: [Track]?
    private var refreshControl = UIRefreshControl()
    private var indicator = UIActivityIndicatorView()
    // MARK: - Override func
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func configUI() {
        tableView.registerNib(TrackTableViewCell)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.addPullToRefreshWithActionHandler {
            self.refresh()
        }
        tableView.addInfiniteScrollingWithActionHandler {
            self.loadMore()
        }
        navigationController?.navigationBar.translucent = false
        tabBarController?.tabBar.translucent = false
    }

    override func loadData() {
        loadSongWithLimit(limit)
    }

    // MARK: - private func
    private func loadSongWithLimit(limit: Int) {
        APIManager.sharedInstance.getTopSong(limit) { (result) in
            self.tracks = result
            self.tableView.reloadData()
            self.tableView.pullToRefreshView.stopAnimating()
            self.tableView.infiniteScrollingView.stopAnimating()
        }

    }

    private func refresh() {
        limit = 10
        loadSongWithLimit(limit)
    }

    private func loadMore() {
        limit += 10
        loadSongWithLimit(limit)
    }
}

//MARK: - extension of UITableViewDelegate and UITableViewDataSource
extension ChartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return TrackTableViewCell.cellHeight()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks?.count ?? 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(TrackTableViewCell)
        if let track = tracks?[indexPath.row] {
            cell.configCellWithTrack(track)
        }
        return cell
    }
}
