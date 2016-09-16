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
        setupImage()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let isPlaying = kAppDelegate?.detailPlayerVC?.getIsPlaying() where isPlaying {
            startRotate()
        } else {
            stopRotate()
        }
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if let isPlaying = kAppDelegate?.detailPlayerVC?.getIsPlaying() where isPlaying {
            stopRotate()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageAvatar.circle()
        imageAvatar.clipsToBounds = true
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

    func reloadImage(urlImage: String?) {
        self.urlImage = urlImage
        setupImage()
    }

    // MARK: - private func
    private func setupImage() {
        if let imageURLString = urlImage, url = NSURL(string: imageURLString) {
            imageAvatar.sd_setImageWithURL(url)
        }
        currentRotateValue = 0.0
        imageAvatar.circle()
        imageAvatar.clipsToBounds = true
        startRotate()
    }

}
