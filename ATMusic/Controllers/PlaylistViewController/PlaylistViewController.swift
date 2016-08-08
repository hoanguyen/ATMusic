//
//  PlaylistViewController.swift
//  ATMusic
//
//  Created by Nguyen Thanh Su on 8/1/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit
import SwiftUtils

private extension CGFloat {
    static let topMargin = 12 * Ratio.width
    static let leftMargin = 18 * Ratio.width
    static let bottomMargin = 13 * Ratio.width
    static let rightMargin = 18 * Ratio.width
    static let naviButtonWidth = 25
    static let naviButtonHeight = 25
}
private extension Selector {
    static let refreshCollectionView = #selector(PlaylistViewController.refreshCollectionView(_:))
    static let addNewTrack = #selector(PlaylistViewController.addNewTrack(_:))
}

class PlaylistViewController: BaseVC {
    // MARK: - private outlet
    @IBOutlet private weak var collectionView: UICollectionView!

    // MARK: - private property
    private var refreshControl = UIRefreshControl()
    private var indicator = UIActivityIndicatorView()
    // fake number cell will display
    private var numberCellInCollectionView = 10

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
        // add the refresh control
        addPullRefreshControl()
        // add indicatior
        addIndicatorToLoadMore()
        // add button on navigation
        addButtonCreatePlaylist()
    }

    private func addButtonCreatePlaylist() {
        let addButton = UIButton(type: .Custom)
        addButton.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: CGFloat.naviButtonWidth, height: CGFloat.naviButtonHeight))
        addButton.setBackgroundImage(UIImage(assetIdentifier: .Add), forState: .Normal)
        addButton.addTarget(self, action: .addNewTrack, forControlEvents: .TouchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addButton)
    }

    private func addIndicatorToLoadMore() {
        indicator.frame = CGRect(origin: CGPoint(x: 0, y: view.bounds.height - 10), size: CGSize(width: view.bounds.width, height: 10))
        indicator.hidesWhenStopped = true
        indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        view.addSubview(indicator)
    }

    private func addPullRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: .refreshCollectionView, forControlEvents: .ValueChanged)
        collectionView.addSubview(refreshControl)
    }

    @objc private func addNewTrack(sender: UIButton) {

    }

    @objc private func refreshCollectionView(sender: AnyObject) {
        print("refreshed")
        numberCellInCollectionView = 10
        collectionView.reloadData()
        refreshControl.endRefreshing()
    }

    private func loadMore() {
        numberCellInCollectionView += 2
        collectionView.reloadData()
        indicator.stopAnimating()
    }
}

//MARK: - extension UICollectionViewDelegate and UICollectionViewDataSource
extension PlaylistViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    // MARK: - UICollectionViewDelegate

    // MARK: - UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberCellInCollectionView
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(PlaylistCell.self, forIndexPath: indexPath)
        cell.configData(index: indexPath.row)
        return cell
    }

    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 10.0 {
            indicator.startAnimating()
            self.loadMore()
        }
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
