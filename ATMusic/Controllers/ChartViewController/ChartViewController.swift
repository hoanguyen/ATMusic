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
    private var playerVC: PlayerViewController?
    private var blurView: UIView?

    // MARK: - Override func
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func configUI() {
        super.configUI()
        tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 49, right: 0)
        tableView.registerNib(TrackTableViewCell)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .None
        tableView.addPullToRefreshWithActionHandler {
            self.loadSong(isRefresh: true)
        }
        tableView.addInfiniteScrollingWithActionHandler {
            self.loadSong(isRefresh: false)
        }
        blurView = View.createPlayerBlurView(frame: PlayerViewController.playerViewFrame())
    }

    override func loadData() {
        songs = [Song]()
        loadSong(isRefresh: true)
    }

    // MARK: - private func
    private func loadSong(isRefresh isRefresh: Bool) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        if isRefresh {
            offset = 0
            songs?.removeAll()
            tableView.reloadData()
        } else {
            offset += limit
        }
        APIManager.sharedInstance.getTopSong(withlimit: limit, atOffset: offset) { (result, error, message) in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            if error {
                print("ERROR: \(message)")
            } else {
                guard let result = result else { return }
                self.songs?.appendContentsOf(result)
                self.tableView.reloadData()
            }
            self.tableView.pullToRefreshView.stopAnimating()
            self.tableView.infiniteScrollingView.stopAnimating()
        }
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
        cell.configCellWithTrack(songs?[indexPath.row], index: indexPath.row)
        cell.delegate = self
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        removeChildView()
        playerVC = PlayerViewController(song: songs?[indexPath.row])
        if let blurView = blurView {
            view.addSubview(blurView)
        }
        if let playerVC = playerVC {
            self.addChildViewController(playerVC)
            playerVC.view.frame = PlayerViewController.playerViewFrame()
            view.addSubview(playerVC.view)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    private func removeChildView() {
        playerVC?.view.removeFromSuperview()
        playerVC?.removeFromParentViewController()
        blurView?.removeFromSuperview()
    }
}

// MARK: - TrackTableViewDelegate
extension ChartViewController: TrackTableViewCellDelegate {
    func didTapMoreButton(tableViewCell: TrackTableViewCell, cellIndex: Int) {
        addSongIntoPlaylist(songs?[cellIndex])
    }
}
