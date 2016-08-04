//
//  SearchViewController.swift
//  ATMusic
//
//  Created by Nguyen Thanh Su on 8/1/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    // MARK: - private outlet
    @IBOutlet private weak var tableView: UITableView!

    // MARK: - private property
    private let searchController = UISearchController(searchResultsController: nil)

    // MARK: - override func
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - private func
    private func configUI() {
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {

    }
}
