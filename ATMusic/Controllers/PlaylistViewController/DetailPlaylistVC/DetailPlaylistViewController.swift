//
//  DetailPlaylistViewController.swift
//  ATMusic
//
//  Created by Nguyen Thanh Su on 8/17/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit

class DetailPlaylistViewController: BaseVC {

    // MARK: - private outlet
    @IBOutlet private weak var avatar: UIImageView!
    @IBOutlet private weak var playlistName: UILabel!
    @IBOutlet private weak var numberOfSong: UILabel!
    @IBOutlet private weak var tableView: UITableView!

    // MARK: - private property
    private var playlist: Playlist?
    private var index = 0

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
        playlistName.text = playlist?.name
        if let number = playlist?.songs.count {
            numberOfSong.text = number > 1 ? "\(number) songs" : "\(number) song"
        }
        tableView.registerNib(TrackTableViewCell)
        tableView.delegate = self
        tableView.dataSource = self
    }

    // MARK: - private func
    @IBAction func didTapEditButton(sender: UIButton) {
    }

    @IBAction func didTapDeleteButton(sender: UIButton) {
        Alert.sharedInstance.showConfirmAlert(self, title: Strings.Warning, message: Strings.Delete) {
            self.navigationController?.popViewControllerAnimated(true)
            NSNotificationCenter.defaultCenter().postNotificationName(
                Strings.NotificationDeletePlaylist,
                object: nil,
                userInfo: [Strings.NotiCellIndex: self.index])
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
}
