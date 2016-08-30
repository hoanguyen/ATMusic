//
//  PlayerViewController.swift
//  ATMusic
//
//  Created by Nguyen Thanh Su on 8/19/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit
import AVFoundation
import SDWebImage
import SwiftUtils

typealias APILoadSongFinished = (data: NSData) -> Void

private let heightView: CGFloat = 55.0 * Ratio.width
private let tabBarHeight: CGFloat = 49.0
private let viewLocation: CGFloat = kScreenSize.height - heightView - tabBarHeight

class PlayerViewController: BaseVC {
    // MARK: - private Outlets
    @IBOutlet private weak var imageAvatar: UIImageView!
    @IBOutlet private weak var songNameLabel: UILabel!
    @IBOutlet private weak var singerNamelabel: UILabel!
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet private weak var contentView: UIView!

    // MARK: - public property
    // public player to delete by his parent
    var player: AVPlayer? // player can not be delete by him self

    // MARK: - private property
    private var song: Song?
    private var songData: NSData?
    private var playing = true
    private var currentRotateValue: CGFloat = 0.0
    private var detailPlayerVC: DetailPlayerViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if playing {
            startRotate()
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    convenience init(song: Song?) {
        self.init()
        self.song = song
    }

    deinit {
        song = nil
        player?.pause()
        player = nil
        songData = nil
    }

    override func configUI() {
        super.configUI()
        view.backgroundColor = UIColor.clearColor()
        if let urlImageString = song?.urlImage, let urlImage = NSURL(string: urlImageString) {
            imageAvatar.sd_setImageWithURL(urlImage)
        }
        imageAvatar.circle()
        songNameLabel.text = song?.songName
        songNameLabel.font = HelveticaFont().Regular(14)
        singerNamelabel.text = song?.singerName
        singerNamelabel.font = HelveticaFont().Regular(11)
        playButton.setBackgroundImage(UIImage(assetIdentifier: .PauseWhite25), forState: .Normal)
        view.addSubview(View.createPlayerBlurView(frame: view.bounds))
        view.bringSubviewToFront(contentView)
        playButton.enabled = true
    }

    override func loadData() {
        super.loadData()
        if let id = song?.id {
            if let url = NSURL(string: "https://api.soundcloud.com/tracks/\(id)/stream?client_id=06c6514c5b35b1617db8c129f7420f02") {
                player = AVPlayer(URL: url)
                player?.play()
                NSNotificationCenter.defaultCenter().addObserver(self,
                    selector: #selector(playerDidFinishPlaying(_:)), name: AVPlayerItemDidPlayToEndTimeNotification, object: nil)

            }
        }
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        stopRotate()
        detailPlayerVC?.dismissViewControllerAnimated(true, completion: {
            print("OK")
        })
        detailPlayerVC = nil
//        detailPlayerVC = DetailPlayerViewController(song: song, playing: playing, player: player)
//        detailPlayerVC?.delegate = self
        if let detailPlayerVC = detailPlayerVC {
            presentViewController(detailPlayerVC, animated: true, completion: nil)
        }
    }

    @objc private func playerDidFinishPlaying(sender: NSNotification) {
        player?.seekToTime(kCMTimeZero)
        player?.play()
    }

    // MARK: - private func
    private func dowloadSong(id: Int?, completionHandler finished: APILoadSongFinished) {
        guard let id = id else { return }
        APIManager.sharedInstance.downloadSong(id) { (data, error, message) in
            if error {
                print("ERROR: \(message)")
            } else {
                guard let data = data else { return }
                finished(data: data)
            }
        }
    }

    private func stopRotate() {
        if let currentRotateValue = imageAvatar.stopRotateView() {
            self.currentRotateValue = currentRotateValue
        }
    }

    private func startRotate() {
        imageAvatar.rotateView(startValue: currentRotateValue, duration: Number.kDurationToRotate)
    }

    private func changePlayStatus() {
        if playing {
            player?.pause()
            playButton.setBackgroundImage(UIImage(assetIdentifier: .PlayWhite25), forState: .Normal)
            stopRotate()
        } else {
            player?.play()
            playButton.setBackgroundImage(UIImage(assetIdentifier: .PauseWhite25), forState: .Normal)
            startRotate()
        }
        playing = !playing
    }

    @IBAction private func playSong(sender: UIButton) {
        changePlayStatus()
    }

    // MARK: - static func
    static func playerViewFrame() -> CGRect {
        return CGRect(origin: CGPoint(x: 0, y: viewLocation), size: CGSize(width: kScreenSize.width, height: heightView))
    }
}

//extension PlayerViewController: DetailPlayerDelegate {
//    func didTapPlayButton(viewController: UIViewController) {
//        changePlayStatus()
//    }
//}
