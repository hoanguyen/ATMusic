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
    @IBOutlet private weak var playlistNameTextField: UITextField!
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
            avatar.sd_setImageWithURL(imageURL, placeholderImage: UIImage(assetIdentifier: .Placeholder))
        }
        playlistNameTextField.text = playlist?.name
        playlistNameTextField.enabled = false
        setTextForNumberSongLabel()
        tableView.registerNib(TrackTableViewCell)
        tableView.delegate = self
        tableView.dataSource = self
        playlistNameTextField.delegate = self
    }

    // MARK: - private func
    @IBAction private func didTapEditButton(sender: UIButton) {
        isEnableForEdit()
    }

    @IBAction private func didTapDeleteButton(sender: UIButton) {
        Alert.sharedInstance.showConfirmAlert(self, title: Strings.Warning, message: Strings.Delete) {
            self.navigationController?.popViewControllerAnimated(true)
            kNotification.postNotificationName(
                Strings.NotificationDeletePlaylist,
                object: nil,
                userInfo: [Strings.NotiCellIndex: self.index])
        }
    }

    private func isEnableForEdit() {
        if isEnable && playlistNameTextField.text != playlist?.name {
            playlist?.setNameWithText(playlistNameTextField.text)
        }
        isEnable = !isEnable
        editButton.setTitle(getTextForButtonEdit(), forState: .Normal)
        playlistNameTextField.enabled = isEnable
        playlistNameTextField.becomeFirstResponder()
        titleLabel.hidden = !isEnable
    }

    private func getTextForButtonEdit() -> String {
        return isEnable ? Strings.Save : Strings.Edit
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
        cell.configCellWithTrack(playlist?.songs[indexPath.row], index: indexPath.row)
        cell.configUIColor()
        return cell
    }

    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .Normal, title: Strings.DeleteString) { (action, indexPath) in
            tableView.beginUpdates()
            self.playlist?.deleteSongAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            tableView.endUpdates()
            self.setTextForNumberSongLabel()
            kNotification.postNotificationName(Strings.NotiDeleteSong,
                object: nil, userInfo: [Strings.NotiCellIndex: indexPath])
        }
        deleteAction.backgroundColor = UIColor.redColor()
        return [deleteAction]
    }
}

//MARK: - TextField Delegate
extension DetailPlaylistViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        isEnableForEdit()
        kNotification.postNotificationName(Strings.NotiChangePlaylistName, object: nil, userInfo: nil)
        return true
    }
}
