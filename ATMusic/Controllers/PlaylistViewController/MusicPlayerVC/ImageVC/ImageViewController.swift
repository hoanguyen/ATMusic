//
//  ImageViewController.swift
//  ATMusic
//
//  Created by Nguyen Thanh Su on 8/29/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit
import SDWebImage

class ImageViewController: UIViewController {

    @IBOutlet private weak var imageAvatar: UIImageView!

    private var currentRotateValue: CGFloat = 0.0
    private var urlImage: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let imageURLString = urlImage, url = NSURL(string: imageURLString) {
            imageAvatar.sd_setImageWithURL(url)
        }
        imageAvatar.circle()
        imageAvatar.clipsToBounds = true
        startRotate()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        startRotate()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        startRotate()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        stopRotate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    convenience init(imageURLString: String?) {
        self.init(nibName: "ImageViewController", bundle: nil)
        urlImage = imageURLString
    }

    func stopRotate() {
        if let currentRotateValue = imageAvatar.stopRotateView() {
            self.currentRotateValue = currentRotateValue
        }
    }

    func startRotate() {
        imageAvatar.rotateView(startValue: currentRotateValue, duration: Number.kDurationToRotate)
    }

}
