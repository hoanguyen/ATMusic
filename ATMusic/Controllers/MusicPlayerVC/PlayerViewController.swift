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
private let kDurationToRotate = 20.0

class PlayerViewController: BaseVC {
    @IBOutlet private weak var imageAvatar: UIImageView!
    @IBOutlet private weak var songNameLabel: UILabel!
    @IBOutlet private weak var singerNamelabel: UILabel!
    @IBOutlet private weak var playButton: UIButton!

    private var song: Song?
    private var songData: NSData?
    private var player: AVPlayer?
    private var playing = true

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    convenience init(song: Song?) {
        self.init()
        self.song = song
    }

    override func configUI() {
        super.configUI()
        view.backgroundColor = UIColor.clearColor()
        if let urlImageString = song?.urlImage, let urlImage = NSURL(string: urlImageString) {
            imageAvatar.sd_setImageWithURL(urlImage)
        }
        imageAvatar.circle()
        imageAvatar.rotateView(kDurationToRotate)
        songNameLabel.text = song?.songName
        singerNamelabel.text = song?.singerName
        playButton.setBackgroundImage(UIImage(assetIdentifier: .PauseWhite25), forState: .Normal)
    }

    override func loadData() {
        super.loadData()
        if let id = song?.id {
            if let url = NSURL(string: "https://api.soundcloud.com/tracks/\(id)/stream?client_id=06c6514c5b35b1617db8c129f7420f02") {
                player = AVPlayer(URL: url)
                player?.play()
                NSNotificationCenter.defaultCenter().addObserver(self,
                    selector: #selector(playerDidFinishPlaying(_:)), name: AVPlayerItemDidPlayToEndTimeNotification, object: nil)
                playButton.enabled = true
            }
        }
    }

    @objc private func playerDidFinishPlaying(sender: NSNotification) {
        player?.seekToTime(kCMTimeZero)
        player?.play()
    }

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

    @IBAction func playSong(sender: UIButton) {
        if playing {
            player?.pause()
            playButton.setBackgroundImage(UIImage(assetIdentifier: .PlayWhite25), forState: .Normal)
            imageAvatar.stopRotateView()
        } else {
            player?.play()
            playButton.setBackgroundImage(UIImage(assetIdentifier: .PauseWhite25), forState: .Normal)
            imageAvatar.rotateView(kDurationToRotate)
        }
        playing = !playing
    }

    // MARK: - static func
    static func playerViewFrame() -> CGRect {
        return CGRect(origin: CGPoint(x: 0, y: viewLocation), size: CGSize(width: kScreenSize.width, height: heightView))
    }
}
