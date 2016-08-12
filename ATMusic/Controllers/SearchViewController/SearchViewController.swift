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
    private weak var searchBar: UISearchBar? = nil
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
        searchBar?.placeholder = "Search"
        searchBar?.delegate = self
        searchBar?.returnKeyType = .Done
        navigationItem.titleView = searchBar

        tableView.registerNib(TrackTableViewCell)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.addPullToRefreshWithActionHandler {
            self.refresh()
        }
        tableView.addInfiniteScrollingWithActionHandler {
            self.loadMore()
        }
    }

    override func loadData() {
        searchBar = UISearchBar()
        songs = [Song]()
    }

    // MARK: - private func

    private func loadSong(whenRefresh isRefresh: Bool) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        APIManager.sharedInstance.searchSong(withKey: searchText, limit: limit, atOffet: offset) { (result, error, message) in
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
            }
            self.tableView.pullToRefreshView.stopAnimating()
            self.tableView.infiniteScrollingView.stopAnimating()
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

    private func hideKeyBoardAndCancelButton() {
        UIView.animateWithDuration(0.7) {
            self.searchBar?.resignFirstResponder()
            self.searchBar?.setShowsCancelButton(false, animated: true)
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
        if let song = songs?[indexPath.row] {
            cell.configCellWithTrack(song)
        }
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
