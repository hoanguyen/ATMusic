//
//  PlaylistViewController.swift
//  ATMusic
//
//  Created by Nguyen Thanh Su on 8/1/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit
import SwiftUtils
import RealmSwift

private extension CGFloat {
    static let topMargin = 0 * Ratio.width
    static let leftMargin = 0 * Ratio.width
    static let bottomMargin = 0 * Ratio.width
    static let rightMargin = 0 * Ratio.width
    static let naviButtonWidth = 25
    static let naviButtonHeight = 25
}

private extension Selector {
    static let addNewPlaylist = #selector(PlaylistViewController.addNewPlaylist(_:))
    static let detailPlaylist = #selector(PlaylistViewController.detailPlaylist(_:))
    static let deletePlaylist = #selector(PlaylistViewController.deletePlaylist(_:))
}

private let kNoSong = 0
private let kOneSong = 1
private let kTwoSongs = 2
private let kThreeSongs = 3

class PlaylistViewController: BaseVC {
    // MARK: - private outlet
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var currentPlaylistName: UILabel!

    // MARK: - private property
    private lazy var playlists: Results<Playlist>? = RealmManager.getAllPlayList()
    private var currentPlaylist: Playlist?
    // MARK: - override func
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func loadData() {
        super.loadData()
        currentPlaylist = playlists?.first
        currentPlaylistName.text = playlists?.first?.name
        addNotification()
    }

    override func configUI() {
        super.configUI()
        // register nib for cell, using library
        collectionView.registerNib(EmptyCell)
        collectionView.registerNib(OneImageCell)
        collectionView.registerNib(TwoImagesCell)
        collectionView.registerNib(ThreeImagesCell)
        collectionView.registerNib(FourImagesCell)
        tableView.registerNib(TrackTableViewCell)
        // delegate and datasource for collectionview and tableview
        collectionView.delegate = self
        collectionView.dataSource = self
        tableView.delegate = self
        tableView.dataSource = self
        // set translucent for tabbar and navigationbar
        navigationController?.navigationBar.translucent = false
        tabBarController?.tabBar.translucent = false
        collectionView.backgroundColor = UIColor.clearColor()
        // show add button
        addButtonCreatePlaylist()
    }

    // MARK: - private action
    @IBAction private func didTapEditButton(sender: UIButton) {
    }

    @IBAction private func didTapNewButton(sender: UIButton) {
    }

    // MARK: - private func
    private func addButtonCreatePlaylist() {
        let addButton = UIButton(type: .Custom)
        addButton.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: CGFloat.naviButtonWidth, height: CGFloat.naviButtonHeight))
        addButton.setBackgroundImage(UIImage(assetIdentifier: .Add), forState: .Normal)
        addButton.addTarget(self, action: .addNewPlaylist, forControlEvents: .TouchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addButton)
    }

    @objc private func addNewPlaylist(sender: UIButton) {
        Alert.sharedInstance.inputTextAlert(self, title: Strings.Create, message: Strings.CreateQuestion) { (text) in
            RealmManager.add(Playlist(name: text))
            self.collectionView.reloadData()
        }
    }

    @objc private func detailPlaylist(sender: NSNotification) {
        if let index = sender.userInfo?[Strings.NotiCellIndex] as? Int {
            let detailPlaylistVC = DetailPlaylistViewController(playlist: playlists?[index], index: index)
            navigationController?.pushViewController(detailPlaylistVC, animated: true)
        }
    }

    @objc private func deletePlaylist(sender: NSNotification) {
        if let index = sender.userInfo?[Strings.NotiCellIndex] as? Int {
            let indexPath = NSIndexPath(forItem: index, inSection: 0)
            RealmManager.delete(playlists?[index])
            collectionView.deleteItemsAtIndexPaths([indexPath])
            collectionView.endEditing(true)
            currentPlaylist = playlists?.first
            tableView.reloadData()
            Alert.sharedInstance.showAlert(self, title: Strings.Success, message: Strings.DeletePlaylistSuccess)
        }
    }

    private func addNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: .detailPlaylist, name: Strings.NotificationDetailPlaylist, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: .deletePlaylist, name: Strings.NotificationDeletePlaylist, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: .addNewPlaylist, name: Strings.NotiAddPlaylist, object: nil)
    }

}

//MARK: - extension UICollectionViewDelegate and UICollectionViewDataSource
extension PlaylistViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    // MARK: - UICollectionViewDelegate

    // MARK: - UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = playlists?.count {
            return count + 1
        }
        return 1
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if indexPath.row == playlists?.count {
            let cell = collectionView.dequeue(EmptyCell.self, forIndexPath: indexPath)
            return cell
        } else {
            if let playlist = playlists?[indexPath.row] {
                if playlist.songs.count == kNoSong || playlist.songs.count == kOneSong {
                    let cell = collectionView.dequeue(OneImageCell.self, forIndexPath: indexPath)
                    cell.configCell(playlist: playlist, index: indexPath.row)
                    return cell
                } else if playlist.songs.count == kTwoSongs {
                    let cell = collectionView.dequeue(TwoImagesCell.self, forIndexPath: indexPath)
                    cell.configCell(playlist: playlist, index: indexPath.row)
                    return cell
                } else if playlist.songs.count == kThreeSongs {
                    let cell = collectionView.dequeue(ThreeImagesCell.self, forIndexPath: indexPath)
                    cell.configCell(playlist: playlist, index: indexPath.row)
                    return cell
                } else {
                    let cell = collectionView.dequeue(FourImagesCell.self, forIndexPath: indexPath)
                    cell.configCell(playlist: playlist, index: indexPath.row)
                    return cell
                }
            }
        }
        return collectionView.dequeue(EmptyCell.self, forIndexPath: indexPath)
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == playlists?.count {
            return
        }
        currentPlaylist = playlists?[indexPath.row]
        currentPlaylistName.text = playlists?[indexPath.row].name
        tableView.reloadData()
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension PlaylistViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            return BaseCell.cellSize()
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: .topMargin, left: .leftMargin, bottom: .bottomMargin, right: .rightMargin)
    }
}

extension PlaylistViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentPlaylist?.songs.count ?? 0
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return TrackTableViewCell.cellHeight()
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(TrackTableViewCell)
        cell.configCellWithTrack(currentPlaylist?.songs[indexPath.row], index: indexPath.row)
        return cell
    }
}
