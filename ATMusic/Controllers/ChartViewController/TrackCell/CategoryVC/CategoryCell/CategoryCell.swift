//
//  CategoryCell.swift
//  ATMusic
//
//  Created by Nguyen Thanh Su on 9/6/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {
    @IBOutlet private weak var cellImage: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var markImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.font = HelveticaFont().Regular(17)
    }

    func configCell(title: String?, imageString: String?, hideMarkImage hide: Bool) {
        titleLabel.text = title
        cellImage.image = UIImage(named: imageString ?? "")
        markImage.hidden = hide
    }
}
