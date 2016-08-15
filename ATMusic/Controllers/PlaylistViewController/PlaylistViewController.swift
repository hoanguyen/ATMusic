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
    static let topMargin = 12 * Ratio.width
    static let leftMargin = 18 * Ratio.width
    static let bottomMargin = 13 * Ratio.width
    static let rightMargin = 18 * Ratio.width
    static let naviButtonWidth = 25
    static let naviButtonHeight = 25
}
private extension Selector {
//    static let refreshCollectionView = #selector(PlaylistViewController.refreshCollectionView(_:))
    static let addNewTrack = #selector(PlaylistViewController.addNewTrack(_:))
}

class PlaylistViewController: BaseVC {
    // MARK: - private outlet
    @IBOutlet private weak var collectionView: UICollectionView!

    // MARK: - private property
    private lazy var playlists: Results<Playlist>? = RealmManager.getAllPlayList()
    // MARK: - override func
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func loadData() {
        super.loadData()
    }

    // MARK: - private func
    override func configUI() {
        super.configUI()
        // register nib for cell, using library
        collectionView.registerNib(PlaylistCell)
        // delegate and datasource for collectionview
        collectionView.delegate = self
        collectionView.dataSource = self
        // set translucent for tabbar and navigationbar
        navigationController?.navigationBar.translucent = false
        tabBarController?.tabBar.translucent = false
        collectionView.backgroundColor = UIColor.clearColor()
        // show add button
        addButtonCreatePlaylist()
    }

    private func addButtonCreatePlaylist() {
        let addButton = UIButton(type: .Custom)
        addButton.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: CGFloat.naviButtonWidth, height: CGFloat.naviButtonHeight))
        addButton.setBackgroundImage(UIImage(assetIdentifier: .Add), forState: .Normal)
        addButton.addTarget(self, action: .addNewTrack, forControlEvents: .TouchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addButton)
    }

    @objc private func addNewTrack(sender: UIButton) {
        Alert.sharedInstance.inputTextAlert(self, title: Strings.Create, message: Strings.CreateQuestion) { (text) in
            RealmManager.add(Playlist(name: text))
            self.collectionView.reloadData()
        }
    }
}

//MARK: - extension UICollectionViewDelegate and UICollectionViewDataSource
extension PlaylistViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    // MARK: - UICollectionViewDelegate

    // MARK: - UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playlists?.count ?? 0
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(PlaylistCell.self, forIndexPath: indexPath)
        cell.configCell(playlist: playlists?[indexPath.row])
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension PlaylistViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            return PlaylistCell.cellSize()
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: .topMargin, left: .leftMargin, bottom: .bottomMargin, right: .rightMargin)
    }
}
