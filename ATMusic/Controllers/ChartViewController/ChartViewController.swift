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

private let kTableviewTopMargin: CGFloat = 64
private let kTableviewBottomMargin: CGFloat = 49

private extension Selector {
    static let addCategoryButton = #selector(ChartViewController.didTapCotegoryButton(_:))
    static let changeToTrendingOrTop = #selector(ChartViewController.didTapToChangeKind(_:))
}

class ChartViewController: BaseVC {
    // MARK: - Private Outlet
    @IBOutlet private weak var tableView: UITableView!

    // MARK: - private property
    private var currentGenre: String = ""
    private var currentKind: String = ""
    private var currentIndexPathOfGenreType = NSIndexPath(forRow: 0, inSection: 0)
    private let limit = 20
    private var offset = 0
    private var songs: [Song]?
    private var rightNaviBarButton: UIBarButtonItem!
    private var indicator: UIActivityIndicatorView?
    private var afterConfigUI = false

    // MARK: - Override func
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func configUI() {
        super.configUI()
        afterConfigUI = true
        tableView.contentInset = UIEdgeInsets(top: kTableviewTopMargin, left: 0, bottom: kTableviewBottomMargin, right: 0)
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
        addCategoryButton()
        addRightNaviButton()
    }

    override func loadData() {
        getGenre()
        currentKind = SoundCloudKind(rawValue: 0)?.path ?? ""
        songs = [Song]()
        loadSong(isRefresh: true)
    }

    // MARK: - private func
    private func getGenre() {
        guard let genreType = GenreType(rawValue: currentIndexPathOfGenreType.section) else { return }
        switch genreType {
        case .All:
            let genre = SoundCloudGenreAll(rawValue: currentIndexPathOfGenreType.row)
            currentGenre = genre?.path ?? ""
            navigationItem.title = genre?.itemName ?? ""
        case .Music:
            let genre = SoundCloudMusic(rawValue: currentIndexPathOfGenreType.row)
            currentGenre = genre?.path ?? ""
            navigationItem.title = genre?.itemName ?? ""
        case .Audio:
            let genre = SoundCloudAudio(rawValue: currentIndexPathOfGenreType.row)
            currentGenre = genre?.path ?? ""
            navigationItem.title = genre?.itemName ?? ""
        }
    }

    @objc private func didTapToChangeKind(sender: UIButton) {
        if currentKind == SoundCloudKind(rawValue: 0)?.path {
            currentKind = SoundCloudKind(rawValue: 1)?.path ?? ""
            rightNaviBarButton = UIBarButtonItem(title: Strings.Trending, style: .Plain, target: self, action: .changeToTrendingOrTop)
            navigationItem.rightBarButtonItem = rightNaviBarButton
        } else {
            currentKind = SoundCloudKind(rawValue: 0)?.path ?? ""
            rightNaviBarButton = UIBarButtonItem(title: Strings.Top, style: .Plain, target: self, action: .changeToTrendingOrTop)
        }
        rightNaviBarButton.enabled = false
        navigationItem.rightBarButtonItem = rightNaviBarButton
        loadSong(isRefresh: true)
        Helper.delay(second: 1) {
            self.rightNaviBarButton.enabled = true
        }
    }

    private func addRightNaviButton() {
//        let rightButton = UIButton(type: .Custom)
//        rightButton.setImage(UIImage(assetIdentifier: .TopRed22), forState: .Normal)
//        rightButton.setImage(UIImage(assetIdentifier: .TrendingRed22), forState: .Selected)
//        rightButton.addTarget(self, action: nil, forControlEvents: .TouchUpInside)

//        rightNaviBarButton = UIButton(type: .System)
//        rightNaviBarButton.setTitle("Top", forState: .Normal)
//        rightNaviBarButton.setTitle("Trending", forState: .Selected)
//        rightNaviBarButton.addTarget(self, action: .changeToTrendingOrTop, forControlEvents: .TouchUpInside)
//        let button = UIBarButtonItem(customView: rightNaviBarButton)

        rightNaviBarButton = UIBarButtonItem(title: Strings.Top, style: .Plain, target: self, action: .changeToTrendingOrTop)
        navigationItem.rightBarButtonItem = rightNaviBarButton

//        navigationItem.rightBarButtonItem = rightButton
    }

    private func addCategoryButton() {
        let leftButton = UIBarButtonItem(title: Strings.Categories, style: .Plain, target: self, action: .addCategoryButton)
        navigationItem.leftBarButtonItem = leftButton
        navigationController?.navigationBar.tintColor = Color.Red225
    }

    private func addIndicator() {
        indicator = UIActivityIndicatorView()
        indicator?.color = Color.Red225
        indicator?.hidesWhenStopped = true
        indicator?.center = view.center
        indicator?.bounds.size = CGSize(width: 30, height: 30)
        view.addSubview(indicator ?? UIView())
        indicator?.startAnimating()
    }

    private func loadSong(isRefresh isRefresh: Bool) {
        if Helper.isConnectedToNetwork() {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            if isRefresh {
                addIndicator()
                offset = 0
                songs?.removeAll()
                tableView.reloadData()
            } else {
                offset += limit
            }
            APIManager.sharedInstance.getSong(withKind: currentKind,
                andGenre: currentGenre,
                limit: limit,
                atOffset: offset) { (result, error, message) in
                    self.indicator?.stopAnimating()
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    if error {
                        print("ERROR: \(message)")
                    } else {
                        guard let result = result else { return }
                        self.songs?.appendContentsOf(result)
                        self.tableView.reloadData()
                        kAppDelegate?.detailPlayerVC?.reloadWhenChangeSongList()
                    }
                    self.tableView.pullToRefreshView.stopAnimating()
                    self.tableView.infiniteScrollingView.stopAnimating()
            }
        } else {
            indicator?.stopAnimating()
            if afterConfigUI {
                tableView.pullToRefreshView.stopAnimating()
                tableView.infiniteScrollingView.stopAnimating()
            }
            Alert.sharedInstance.showAlert(self, title: Strings.Error, message: Strings.DisconnectedNetwork)
        }
    }

    @objc private func didTapCotegoryButton(sender: UIButton) {
        let categoryVC = CategoryViewController(selectRowAtIndexPath: currentIndexPathOfGenreType)
        categoryVC.delegate = self
        presentViewController(categoryVC, animated: true, completion: nil)
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
        if Helper.isConnectedToNetwork() {
            if kAppDelegate?.detailPlayerVC?.currentSongID() != songs?[indexPath.row].id {
                kAppDelegate?.detailPlayerVC?.player = nil
                kAppDelegate?.detailPlayerVC?.dataSource = nil
                kAppDelegate?.detailPlayerVC = nil
                kAppDelegate?.detailPlayerVC = DetailPlayerViewController(song: songs?[indexPath.row],
                    songIndex: indexPath.row, playlistName: Strings.Trending)
                if let detailPlayerVC = kAppDelegate?.detailPlayerVC {
                    detailPlayerVC.dataSource = self
                    tabBarController?.presentPopupBarWithContentViewController(detailPlayerVC, animated: true, completion: nil)
                }
            }
        } else {
            Alert.sharedInstance.showAlert(self, title: Strings.Error, message: Strings.DisconnectedNetwork)
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
extension ChartViewController: DetailPlayerDataSource {
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

//MARK: - CategoryVC Delegate
extension ChartViewController: CategoryViewControllerDelegate {
    func categoryViewController(viewController: UIViewController, didSelectCategoryAtIndexPath indexPath: NSIndexPath) {
        currentIndexPathOfGenreType = indexPath
        getGenre()
        loadSong(isRefresh: true)
    }
}
