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
    static let longPress = #selector(PlaylistViewController.handleTableViewLongGesture(_:))
    static let deleteSong = #selector(PlaylistViewController.deleteSong(_:))
    static let changeName = #selector(PlaylistViewController.changeName(_:))
    static let reloadWhenAddNew = #selector(PlaylistViewController.reloadCollectionView(_:))
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
    private var snapShot: UIView?
    private var sourceIndexPath: NSIndexPath?
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
        addLongPressGestureRecognizer()
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
        reloadWhenTapToChangePlaylist()
        currentPlaylistName.font = HelveticaFont().Regular(15)
    }

    // MARK: - private func
    private func addButtonCreatePlaylist() {
        let addButton = UIButton(type: .Custom)
        addButton.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: CGFloat.naviButtonWidth, height: CGFloat.naviButtonHeight))
        addButton.setBackgroundImage(UIImage(assetIdentifier: .Add), forState: .Normal)
        addButton.addTarget(self, action: .addNewPlaylist, forControlEvents: .TouchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addButton)
    }

    @objc private func reloadCollectionView(sender: NSNotification) {
        collectionView.reloadData()
        currentPlaylist = playlists?.first
        reloadWhenTapToChangePlaylist()
    }

    @objc private func addNewPlaylist(sender: UIButton) {
        let playlistNameObject = PlaylistName.firstItemFree()
        Alert.sharedInstance.inputTextAlert(self, title: Strings.Create,
            message: Strings.CreateQuestion, placeholder: Strings.PlaylistNamePlaceHolder + " \(playlistNameObject.id)") { (text, isUse) in
                playlistNameObject.setUsing(isUse)
                if !isUse && Helper.checkingPlayList(text) {
                    if let item = PlaylistName.getItemWithName(text) {
                        item.setUsing(true)
                    } else {
                        RealmManager.add(PlaylistName(isUse: true))
                    }
                }
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

    @objc private func deleteSong(sender: NSNotification) {
        if let indexPath = sender.userInfo?[Strings.NotiCellIndex] as? NSIndexPath {
            reloadTableViewWhenDeleteSong(indexPath)
        }
    }

    @objc private func changeName(sender: NSNotification) {
        reloadWhenTapToChangePlaylist()
    }

    @objc private func deletePlaylist(sender: NSNotification) {
        if let index = sender.userInfo?[Strings.NotiCellIndex] as? Int {
            RealmManager.delete(playlists?[index])
            collectionView.reloadData()
            currentPlaylist = playlists?.first
            reloadWhenTapToChangePlaylist()
            Alert.sharedInstance.showAlert(self, title: Strings.Success, message: Strings.DeletePlaylistSuccess)
        }
    }

    @objc private func handleTableViewLongGesture(sender: UILongPressGestureRecognizer) {
        let state = sender.state
        var location = sender.locationInView(tableView)
        location.y = handleOverSizeOfTableView(location.y)
        guard let indexPath = tableView.indexPathForRowAtPoint(location) else { return }
        switch state {
        case .Began:
            sourceIndexPath = indexPath
            guard let cell = tableView.cellForRowAtIndexPath(indexPath) else { return }
            // Take a snapshot of the selected row using helper method.
            snapShot = customSnapShotFromView(cell)
            // Add the snapshot as subview, centered at cell's center...
            var center = CGPoint(x: cell.center.x, y: cell.center.y)
            snapShot?.center = center
            snapShot?.alpha = 0.0
            guard let snapShot = snapShot else { return }
            tableView.addSubview(snapShot)
            UIView.animateWithDuration(0.25, animations: {
                // Offset for gesture location.
                center.y = location.y
                self.snapShot?.center = center
                self.snapShot?.transform = CGAffineTransformMakeScale(1.05, 1.05)
                self.snapShot?.alpha = 0.98
                cell.alpha = 0.0
                }, completion: { _ in
                cell.hidden = true
            })
        case .Changed:
            guard let snapShot = snapShot, sourceIndexPathTmp = sourceIndexPath else { return }
            var center = snapShot.center
            center.y = location.y
            snapShot.center = center

            // Is destination valid and is it different from source?
            if !indexPath.isEqual(sourceIndexPathTmp) {
                // self made exchange method
                exchangeObjectAtIndex(index: indexPath.row, withObjectAtIndex: sourceIndexPathTmp.row)
                // ... move the rows.
                tableView.moveRowAtIndexPath(sourceIndexPathTmp, toIndexPath: indexPath)
                // ... and update source so it is in sync with UI changes.
                sourceIndexPath = indexPath
            }
        default:
            guard let sourceIndexPathTmp = sourceIndexPath else { return }
            guard let cell = tableView.cellForRowAtIndexPath(sourceIndexPathTmp) else { return }
            cell.hidden = false
            cell.alpha = 0.0

            UIView.animateWithDuration(0.25, animations: {
                self.snapShot?.center = cell.center
                self.snapShot?.transform = CGAffineTransformIdentity
                self.snapShot?.alpha = 0.0

                cell.alpha = 1.0
                }, completion: { _ in
                self.sourceIndexPath = nil
                self.snapShot?.removeFromSuperview()
                self.snapShot = nil
            })
        }
    }

    private func exchangeObjectAtIndex(index firstIndex: Int, withObjectAtIndex secondIndex: Int) {
        if let songs = currentPlaylist?.songs where songs.count > 0 {
            RealmManager.changePosition(songs, atFirst: firstIndex, withSecond: secondIndex)
        }
        let firstIndexPath = NSIndexPath(forRow: firstIndex, inSection: 0)
        let secondIndexPath = NSIndexPath(forRow: secondIndex, inSection: 0)
        let firstCell = tableView.cellForRowAtIndexPath(firstIndexPath) as? TrackTableViewCell
        let secondCell = tableView.cellForRowAtIndexPath(secondIndexPath) as? TrackTableViewCell
        firstCell?.changeIndex(firstIndex)
        secondCell?.changeIndex(secondIndex)
    }
    func handleOverSizeOfTableView(position: CGFloat) -> CGFloat {
        var positionTmp = position
        if positionTmp <= 0 {
            positionTmp = 1
        } else if position >= tableView.contentSize.height {
            positionTmp = tableView.contentSize.height - 1
        }
        return positionTmp
    }

    func customSnapShotFromView(inputView: UIView) -> UIImageView {
        // Make an image from the input view.
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0)
        inputView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        let snapshot = UIImageView(image: image)
        snapshot.layer.masksToBounds = false
        snapshot.layer.cornerRadius = 0.0
        snapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
        snapshot.layer.shadowRadius = 5.0
        snapshot.layer.shadowOpacity = 0.4

        return snapshot
    }

    private func addNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: .detailPlaylist, name: Strings.NotificationDetailPlaylist, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: .deletePlaylist, name: Strings.NotificationDeletePlaylist, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: .addNewPlaylist, name: Strings.NotiAddPlaylist, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: .deleteSong, name: Strings.NotiDeleteSong, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: .changeName, name: Strings.NotiChangePlaylistName, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: .reloadWhenAddNew, name: Strings.NotiReloadWhenAddNew, object: nil)
    }

    private func addLongPressGestureRecognizer() {
        let longPress = UILongPressGestureRecognizer(target: self, action: .longPress)
        tableView.addGestureRecognizer(longPress)
    }

    private func reloadWhenTapToChangePlaylist() {
        currentPlaylistName.text = currentPlaylist?.name
        tableView.reloadData()
    }

    private func reloadTableViewWhenDeleteSong(indexPath: NSIndexPath) {
        tableView.beginUpdates()
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        self.collectionView.reloadData()
        tableView.endUpdates()
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
        reloadWhenTapToChangePlaylist()
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

//MARK: - TableView Delegate and DataSource
extension PlaylistViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentPlaylist?.songs.count ?? 0
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return TrackTableViewCell.cellHeight()
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(TrackTableViewCell)
        cell.configCellWithTrack(currentPlaylist?.songs[indexPath.row], index: indexPath.row, showButtonMore: false)
        return cell
    }

    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .Normal, title: "Delete") { (action, indexPath) in
            self.currentPlaylist?.deleteSongAtIndex(indexPath.row)
            self.reloadTableViewWhenDeleteSong(indexPath)
        }
        deleteAction.backgroundColor = UIColor.redColor()
        return [deleteAction]
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if kAppDelegate?.detailPlayerVC?.currentSongID() != currentPlaylist?.songs[indexPath.row].id {
            kAppDelegate?.detailPlayerVC?.player = nil
            kAppDelegate?.detailPlayerVC?.delegate = nil
            kAppDelegate?.detailPlayerVC?.dataSource = nil
            kAppDelegate?.detailPlayerVC = nil
            kAppDelegate?.detailPlayerVC = DetailPlayerViewController(song: currentPlaylist?.songs[indexPath.row],
                songIndex: indexPath.row, playlistName: currentPlaylist?.name)
            if let detailPlayerVC = kAppDelegate?.detailPlayerVC {
                detailPlayerVC.delegate = self
                detailPlayerVC.dataSource = self
                tabBarController?.presentPopupBarWithContentViewController(detailPlayerVC, animated: true, completion: nil)
            }
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

//MARK: - DetailPlayerDelegate
extension PlaylistViewController: DetailPlayerDelegate, DetailPlayerDataSource {
    func detailPlayer(viewController: UIViewController, changeToSongAtIndex index: Int) {
        print(index)
    }

    func numberOfSongInPlaylist(viewController: UIViewController) -> Int? {
        return currentPlaylist?.songs.count
    }

    func songInPlaylist(viewController: UIViewController, atIndex index: Int) -> Song? {
        return currentPlaylist?.songs[index]
    }

    func songNameList(viewController: UIViewController) -> [String]? {
        var songNameList = [String]()
        guard let songs = currentPlaylist?.songs else { return nil }
        for item in songs {
            if let name = item.songName {
                songNameList.append(name)
            }
        }
        return songNameList
    }
}
