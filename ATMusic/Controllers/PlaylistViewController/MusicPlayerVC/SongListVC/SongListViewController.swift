//
//  SongListViewController.swift
//  ATMusic
//
//  Created by Nguyen Thanh Su on 8/29/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit

class SongListViewController: BaseVC {
    @IBOutlet private weak var tableView: UITableView!

    private var songNameList: [String]?
    private var playingIndex: Int = -1
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    convenience init(songNameList: [String]?, playAtIndex playingIndex: Int) {
        self.init(nibName: "SongListViewController", bundle: nil)
        self.songNameList = songNameList
        self.playingIndex = playingIndex
    }

    override func configUI() {
        super.configUI()
        tableView.registerNib(SongListCell)
        tableView.separatorStyle = .None
    }

    override func loadData() {
        super.loadData()
    }
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
}
