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
import LNPopupController

class ChartViewController: BaseVC {
    // MARK: - Private Outlet
    @IBOutlet private weak var tableView: UITableView!
    private let limit = 10
    private var offset = 0
    private var songs: [Song]?
    private var playerVC: PlayerViewController?

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
        cell.configCellWithTrack(songs?[indexPath.row], index: indexPath.row, showButtonMore: true)
        cell.delegate = self
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if kAppDelegate?.detailPlayerVC?.currentSongID() != songs?[indexPath.row].id {
            kAppDelegate?.detailPlayerVC?.player = nil
            kAppDelegate?.detailPlayerVC?.delegate = nil
            kAppDelegate?.detailPlayerVC?.dataSource = nil
            kAppDelegate?.detailPlayerVC = nil
            kAppDelegate?.detailPlayerVC = DetailPlayerViewController(song: songs?[indexPath.row], songIndex: indexPath.row)
            if let detailPlayerVC = kAppDelegate?.detailPlayerVC {
                detailPlayerVC.delegate = self
                detailPlayerVC.dataSource = self
                tabBarController?.presentPopupBarWithContentViewController(detailPlayerVC, animated: true, completion: nil)
            }
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

// MARK: - TrackTableViewDelegate
extension ChartViewController: TrackTableViewCellDelegate {
    func didTapMoreButton(tableViewCell: TrackTableViewCell, cellIndex: Int) {
        addSongIntoPlaylist(songs?[cellIndex])
    }
}

//MARK: - DetailPlayerDelegate
extension ChartViewController: DetailPlayerDelegate, DetailPlayerDataSource {
    func detailPlayer(viewController: UIViewController, changeToSongAtIndex index: Int) {
        print(index)
    }

    func numberOfSongInPlaylist(viewController: UIViewController) -> Int? {
        return songs?.count
    }

    func songInPlaylist(viewController: UIViewController, atIndex index: Int) -> Song? {
        return songs?[index]
    }

    func songNameList(viewController: UIViewController) -> [String]? {
        var songNameList = [String]()
        guard let songs = songs else { return nil }
        for item in songs {
            if let name = item.songName {
                songNameList.append(name)
            }
        }
        return songNameList
    }
}
