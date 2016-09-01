//
//  DetailPlaylistViewController.swift
//  ATMusic
//
//  Created by Nguyen Thanh Su on 8/17/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit
import SDWebImage

class DetailPlaylistViewController: BaseVC {

    // MARK: - private outlet
    @IBOutlet private weak var avatar: UIImageView!
    @IBOutlet private weak var playlistNameTF: UITextField!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var numberOfSong: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var editButton: UIButton!

    // MARK: - private property
    private var playlist: Playlist?
    private var index = 0
    private var isEnable = false

    // MARK: - override func
    convenience init(playlist: Playlist?, index: Int) {
        self.init()
        self.playlist = playlist
        self.index = index
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func configUI() {
        if let imageURLString = playlist?.songs.first?.urlImage, imageURL = NSURL(string: imageURLString) {
            avatar.sd_setImageWithURL(imageURL)
        }
        playlistNameTF.text = playlist?.name
        playlistNameTF.enabled = false
        setTextForNumberSongLabel()
        tableView.registerNib(TrackTableViewCell)
        tableView.delegate = self
        tableView.dataSource = self
        playlistNameTF.delegate = self
    }

    // MARK: - private func
    @IBAction private func didTapEditButton(sender: UIButton) {
        isEnableForEdit()
    }

    @IBAction private func didTapDeleteButton(sender: UIButton) {
        Alert.sharedInstance.showConfirmAlert(self, title: Strings.Warning, message: Strings.Delete) {
            if Helper.checkingPlayList(self.playlist?.name) {
                if let item = PlaylistName.getItemWithName(self.playlist?.name) {
                    item.setUsing(false)
                }
            }
            self.navigationController?.popViewControllerAnimated(true)
            NSNotificationCenter.defaultCenter().postNotificationName(
                Strings.NotificationDeletePlaylist,
                object: nil,
                userInfo: [Strings.NotiCellIndex: self.index])
        }
    }

    private func isEnableForEdit() {
        if isEnable {
            if playlistNameTF.text != playlist?.name {
                playlist?.setNameWithText(playlistNameTF.text)
            }
        }
        isEnable = !isEnable
        editButton.setTitle(getTextForButtonEdit(), forState: .Normal)
        playlistNameTF.enabled = isEnable
        playlistNameTF.becomeFirstResponder()
        titleLabel.hidden = !isEnable
    }

    private func getTextForButtonEdit() -> String {
        switch isEnable {
        case true:
            return "SAVE"
        case false:
            return "EDIT"
        }
    }

    private func setTextForNumberSongLabel() {
        if let number = playlist?.songs.count {
            numberOfSong.text = number > 1 ? "\(number) songs" : "\(number) song"
        }
    }
}

// MARK: - TableView delegate and datasource
extension DetailPlaylistViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return TrackTableViewCell.cellHeight()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlist?.songs.count ?? 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(TrackTableViewCell)
        cell.configCellWithTrack(playlist?.songs[indexPath.row], index: indexPath.row, showButtonMore: false)
        return cell
    }

    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .Normal, title: "Delete") { (action, indexPath) in
            tableView.beginUpdates()
            self.playlist?.deleteSongAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            tableView.endUpdates()
            self.setTextForNumberSongLabel()
            NSNotificationCenter.defaultCenter().postNotificationName(Strings.NotiDeleteSong,
                object: nil, userInfo: [Strings.NotiCellIndex: indexPath])
        }
        deleteAction.backgroundColor = UIColor.redColor()
        return [deleteAction]
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if kAppDelegate?.detailPlayerVC?.currentSongID() != playlist?.songs[indexPath.row].id {
            kAppDelegate?.detailPlayerVC?.player = nil
            kAppDelegate?.detailPlayerVC?.delegate = nil
            kAppDelegate?.detailPlayerVC?.dataSource = nil
            kAppDelegate?.detailPlayerVC = nil
            kAppDelegate?.detailPlayerVC = DetailPlayerViewController(song: playlist?.songs[indexPath.row],
                songIndex: indexPath.row, playlistName: playlist?.name)
            if let detailPlayerVC = kAppDelegate?.detailPlayerVC {
                detailPlayerVC.delegate = self
                detailPlayerVC.dataSource = self
                tabBarController?.presentPopupBarWithContentViewController(detailPlayerVC, animated: true, completion: nil)
            }
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

//MARK: - TextField Delegate
extension DetailPlaylistViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        isEnableForEdit()
        NSNotificationCenter.defaultCenter().postNotificationName(Strings.NotiChangePlaylistName, object: nil, userInfo: nil)
        return true
    }
}

//MARK: - DetailPlayerDelegate
extension DetailPlaylistViewController: DetailPlayerDelegate, DetailPlayerDataSource {
    func detailPlayer(viewController: UIViewController, changeToSongAtIndex index: Int) {
        print(index)
    }

    func numberOfSongInPlaylist(viewController: UIViewController) -> Int? {
        return playlist?.songs.count
    }

    func songInPlaylist(viewController: UIViewController, atIndex index: Int) -> Song? {
        return playlist?.songs[index]
    }

    func songNameList(viewController: UIViewController) -> [String]? {
        return nil
    }
}
