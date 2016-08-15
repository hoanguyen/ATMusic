//
//  SearchViewController.swift
//  ATMusic
//
//  Created by Nguyen Thanh Su on 8/1/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit
import SVPullToRefresh

class SearchViewController: BaseVC {
    // MARK: - private outlet
    @IBOutlet private weak var tableView: UITableView!

    // MARK: - private property
    private let limit = 10
    private var offset = 0
    private var songs: [Song]?
    private var searchText = ""
    // MARK: - override func
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        hideKeyBoardAndCancelButton()
    }

    override func configUI() {
        super.configUI()
        tableView.contentInset = UIEdgeInsets(top: 108, left: 0, bottom: 49, right: 0)
        tableView.registerNib(TrackTableViewCell)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.addPullToRefreshWithActionHandler {
            self.loadSong(isRefresh: true)
        }
        tableView.addInfiniteScrollingWithActionHandler {
            self.loadSong(isRefresh: false)
        }
    }

    override func loadData() {
        songs = [Song]()
    }

    // MARK: - private func

    private func loadSong(isRefresh isRefresh: Bool) {
        if isRefresh {
            songs?.removeAll()
            tableView.reloadData()
            offset = 0
        } else {
            offset += limit
        }
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        APIManager.sharedInstance.searchSong(withKey: searchText, limit: limit, atOffet: offset) { (result, error, message) in
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

    private func hideKeyBoardAndCancelButton() {
        UIView.animateWithDuration(0.7) {
        }
    }
}

// MARK: - UITableViewDelegate and DataSource
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return TrackTableViewCell.cellHeight()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs?.count ?? 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(TrackTableViewCell)
        cell.configCellWithTrack(songs?[indexPath.row])
        return cell
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        hideKeyBoardAndCancelButton()
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        hideKeyBoardAndCancelButton()
    }

    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        hideKeyBoardAndCancelButton()
    }

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        APIManager.sharedInstance.cancel()
        if searchText == "" {
            songs?.removeAll()
            tableView.reloadData()
        }
        if searchText.characters.last == " " {
            return
        }
        self.searchText = searchText
        APIManager.sharedInstance.searchSong(withKey: searchText, limit: limit, atOffet: offset) { (result, error, message) in
            if error {
                print("ERROR: \(message)")
            } else {
                self.songs = result
                self.tableView.reloadData()
            }
        }
    }

}
