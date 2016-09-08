//
//  CategoryViewController.swift
//  ATMusic
//
//  Created by Nguyen Thanh Su on 9/6/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit

private let kNumberSection = 3

protocol CategoryViewControllerDelegate {
    func categoryViewController(viewController: UIViewController, didSelectCategoryAtIndexPath indexPath: NSIndexPath)
}

class CategoryViewController: BaseVC {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var cancelButton: UIButton!

    var delegate: CategoryViewControllerDelegate?
    var indexPath = NSIndexPath()

    convenience init(selectRowAtIndexPath indexPath: NSIndexPath) {
        self.init()
        self.indexPath = indexPath
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func configUI() {
        super.configUI()
    }

    override func loadData() {
        super.loadData()
        tableView.registerNib(CategoryCell)
        tableView.separatorStyle = .None
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - private Action
    @IBAction private func didTapDismisButton(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - private func
}

extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return kNumberSection
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GenreType(rawValue: section)?.numberOfItem ?? 0
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return GenreType(rawValue: section)?.title
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(CategoryCell)
        let hide = self.indexPath == indexPath ? false : true
        guard let genre = GenreType(rawValue: indexPath.section) else { return cell }
        switch genre {
        case .All:
            cell.configCell(SoundCloudGenreAll(rawValue: indexPath.row)?.itemName,
                imageString: indexPath.row == 0 ? Strings.Music : Strings.Audio,
                hideMarkImage: hide)
        case .Music:
            cell.configCell(SoundCloudMusic(rawValue: indexPath.row)?.itemName,
                imageString: Strings.Music,
                hideMarkImage: hide)
        case .Audio:
            cell.configCell(SoundCloudAudio(rawValue: indexPath.row)?.itemName,
                imageString: Strings.Audio,
                hideMarkImage: hide)
        }
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        delegate?.categoryViewController(self, didSelectCategoryAtIndexPath: indexPath)
        dismissViewControllerAnimated(true, completion: nil)
    }
}
