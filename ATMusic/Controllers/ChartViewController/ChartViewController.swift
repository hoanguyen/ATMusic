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
    private let limit = 10
    private var offset = 0
    private var songs: [Song]?
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
        tableView.separatorStyle = .None
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
        songs = [Song]()
        loadSong(whenRefresh: false)
    }

    // MARK: - private func
    @objc private func addPlaylist(sender: NSNotification) {
//        Alert.sharedInstance.
    }

    private func loadSong(whenRefresh isRefresh: Bool) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        APIManager.sharedInstance.getTopSong(withlimit: limit, atOffset: offset) { (result, error, message) in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            if error {
                print("ERROR: \(message)")
            } else {
                if isRefresh {
                    self.songs?.removeAll()
                }
                guard let result = result else { return }
                self.songs?.appendContentsOf(result)
                self.tableView.reloadData()
                self.tableView.pullToRefreshView.stopAnimating()
                self.tableView.infiniteScrollingView.stopAnimating()
            }
        }
    }

    private func refresh() {
        offset = 0
        loadSong(whenRefresh: true)
    }

    private func loadMore() {
        offset += limit
        loadSong(whenRefresh: false)
    }
}

//MARK: - extension of UITableViewDelegate and UITableViewDataSource
extension ChartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return TrackTableViewCell.cellHeight()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs?.count ?? 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(TrackTableViewCell)
        if let track = songs?[indexPath.row] {
            cell.configCellWithTrack(track, index: indexPath.row)
            cell.delegate = self
        }
        return cell
    }

    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

// MARK: - TrackTableViewDelegate
extension ChartViewController: TrackTableViewCellDelegate {
    func didTapMoreButton(tableViewCell: TrackTableViewCell, cellIndex: Int) {
        addSongIntoPlaylist(songs?[cellIndex])
    }
}
