//
//  SongListViewController.swift
//  ATMusic
//
//  Created by Nguyen Thanh Su on 8/29/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit

protocol SongListControllerDelegate: NSObjectProtocol {
    func songListViewController(viewController: UIViewController, didSelectSongAtIndex index: Int)
}

class SongListViewController: BaseVC {
    // MARK: - private outlet
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var playlistNameLabel: UILabel!

    // MARK: - public property
    weak var delegate: SongListControllerDelegate?
    var playingIndex = -1

    // MARK: - private property
    private var songNameList: [String]?
    private var playlistName: String?

    // MARK: - override func
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    convenience init(songNameList: [String]?, playAtIndex playingIndex: Int, playlistName: String?) {
        self.init(nibName: "SongListViewController", bundle: nil)
        self.songNameList = songNameList
        self.playingIndex = playingIndex
        self.playlistName = playlistName
    }

    override func configUI() {
        super.configUI()
        tableView.registerNib(SongListCell)
        tableView.separatorStyle = .None
        tableView.headerViewForSection(0)?.backgroundColor = .clearColor()
        tableView.headerViewForSection(0)?.textLabel?.textColor = Color.White233
        playlistNameLabel.text = "Playlist: \(playlistName ?? "")"
        playlistNameLabel.font = HelveticaFont().Regular(17)
    }

    override func loadData() {
        super.loadData()
    }

    func highlightCellAtIndex(index: Int) {
        let oldIndex = playingIndex
        playingIndex = index
        let newIndextPath = NSIndexPath(forRow: playingIndex, inSection: 0)
        let oldIndextPath = NSIndexPath(forRow: oldIndex, inSection: 0)
        tableView.beginUpdates()
        let oldCell = tableView.cellForRowAtIndexPath(oldIndextPath) as? SongListCell
        let newCell = tableView.cellForRowAtIndexPath(newIndextPath) as? SongListCell
        oldCell?.reloadWithPlayingIndex(playingIndex)
        newCell?.reloadWithPlayingIndex(playingIndex)
        tableView.scrollToRowAtIndexPath(newIndextPath, atScrollPosition: .Middle, animated: true)
        tableView.endUpdates()
    }

    func reloadWhenChangeSongList(songNameList: [String]?) {
        self.songNameList = songNameList
        tableView.reloadData()
    }

    // MARK: - private fuc

}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SongListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return SongListCell.cellHeight()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songNameList?.count ?? 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(SongListCell)
        cell.configCellWithname(songNameList?[indexPath.row], andIndex: indexPath.row, playingAtIndex: playingIndex)
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        delegate?.songListViewController(self, didSelectSongAtIndex: indexPath.row)
    }
}
