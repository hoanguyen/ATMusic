//
//  SongListViewController.swift
//  ATMusic
//
//  Created by Nguyen Thanh Su on 8/29/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit

protocol SongListControllerDelegate {
    func songListViewController(viewController: UIViewController, didSelectSongAtIndex index: Int)
}

class SongListViewController: BaseVC {
    // MARK: - private outlet
    @IBOutlet private weak var tableView: UITableView!

    // MARK: - public property
    var delegate: SongListControllerDelegate?

    // MARK: - private property
    private var songNameList: [String]?
    private var playingIndex = -1
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
        tableView.registerNib(SongListHeader)
        tableView.separatorStyle = .None
        tableView.headerViewForSection(0)?.backgroundColor = .clearColor()
        tableView.headerViewForSection(0)?.textLabel?.textColor = Color.White233
    }

    override func loadData() {
        super.loadData()
    }

    func highlightCellAtIndex(index: Int) {
        let newIndextPath = NSIndexPath(forRow: index, inSection: 0)
        let oldIndextPath = NSIndexPath(forRow: playingIndex, inSection: 0)
        tableView.beginUpdates()
        let oldCell = tableView.cellForRowAtIndexPath(oldIndextPath) as? SongListCell
        let newCell = tableView.cellForRowAtIndexPath(newIndextPath) as? SongListCell
        oldCell?.reloadWithPlayingIndex(index)
        newCell?.reloadWithPlayingIndex(index)
        tableView.scrollToRowAtIndexPath(newIndextPath, atScrollPosition: .Middle, animated: true)
        tableView.endUpdates()
        playingIndex = index
    }

    func reloadWhenChangeSongList(songNameList: [String]?) {
        self.songNameList = songNameList
        tableView.reloadData()
    }

    // MARK: - private fuc

}

extension SongListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return SongListCell.cellHeight()
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return SongListHeader.headerHeight()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songNameList?.count ?? 0
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeue(SongListHeader)
        header.configHeaderWithName(playlistName)
        return header
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
