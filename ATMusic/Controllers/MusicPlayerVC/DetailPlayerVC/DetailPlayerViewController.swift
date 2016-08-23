//
//  DetailPlayerViewController.swift
//  ATMusic
//
//  Created by Nguyen Thanh Su on 8/23/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit
import SDWebImage
import AVFoundation

protocol DetailPlayerDelegate {
    func didTapPlayButton(viewController: UIViewController)
}

class DetailPlayerViewController: BaseVC {
    // MARK: - private Outlets
    @IBOutlet private weak var imageAvatar: UIImageView!
    @IBOutlet private weak var songNameLabel: UILabel!
    @IBOutlet private weak var singerNameLabel: UILabel!
    @IBOutlet private weak var startButton: UIButton!
    @IBOutlet private weak var repeatButton: UIButton!
    @IBOutlet private weak var shuffleButton: UIButton!
    @IBOutlet private weak var restDurationLabel: UILabel!
    @IBOutlet private weak var currentDurationLabel: UILabel!
    @IBOutlet private weak var durationSlider: UISlider!
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var mainView: UIView!

    // MARK: - public property
    var delegate: DetailPlayerDelegate?

    // MARK: - private property
    private var song: Song?
    private var currentRotateValue: CGFloat = 0.0
    private var playing = true
    private var player: AVPlayer?

    // MARK: override func
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

    convenience init(song: Song?, playing: Bool, player: AVPlayer?) {
        self.init()
        self.song = song
        self.playing = playing
        self.player = player
    }

    convenience init(playlist: Playlist?) {
        self.init()
    }

    override func loadData() {
        super.loadData()

    }

    override func configUI() {
        super.configUI()
        setupImage()
        // create blur view
        let blurView = View.createPlayerBlurView(frame: view.bounds)
        view.addSubview(blurView)
        view.bringSubviewToFront(mainView)
        imageAvatar.circle()
        view.tintColor = UIColor.whiteColor()
        setupLabel()
    }

    // MARK: - private func
    private func updateCurrentPlayTime() {
        let interval = CMTimeMakeWithSeconds(1.0, 1)
        player?.addPeriodicTimeObserverForInterval(interval, queue: nil, usingBlock: { (cmTime) in
            self.updateChangeForLabel(self.convertToSecond(cmTime))
        })
    }

    private func convertToSecond(time: CMTime?) -> Int? {
        guard let time = time else { return nil }
        return Int(CMTimeGetSeconds(time))
    }

    private func updateChangeForLabel(second: Int?) {
        guard let second = second else { return }
        self.currentDurationLabel.text = second.convertToMinute()
        self.durationSlider.value = Float(second)
    }

    private func setupLabel() {
        currentDurationLabel.font = HelveticaFont().Regular(11)
        singerNameLabel.font = HelveticaFont().Regular(11)
        restDurationLabel.font = HelveticaFont().Regular(11)
        songNameLabel.font = HelveticaFont().Regular(15)
        songNameLabel.text = song?.songName
        singerNameLabel.text = song?.singerName
        if let duration = player?.currentItem?.asset.duration, let second = convertToSecond(duration) {
            restDurationLabel.text = second.convertToMinute()
            durationSlider.maximumValue = Float(second)
        }
        if let currentTime = player?.currentTime(), let second = convertToSecond(currentTime) {
            currentDurationLabel.text = second.convertToMinute()
            durationSlider.value = Float(second)
        }
        updateCurrentPlayTime()
    }
    private func setupImage() {
        if let imageURLString = song?.urlImage, let url = NSURL(string: imageURLString) {
            backgroundImageView.sd_setImageWithURL(url)
            imageAvatar.sd_setImageWithURL(url)
        }
        if playing {
            playButton.setBackgroundImage(UIImage(assetIdentifier: .PauseWhite60), forState: .Normal)
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

    // MARK: - private Actions
    @IBAction private func tapToDismis(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction private func didTapButtonMore(sender: UIButton) {
    }

    @IBAction private func addToFavourite(sender: UIButton) {
    }

    @IBAction private func changeRepeatMode(sender: UIButton) {
    }

    @IBAction private func changeShuffleMode(sender: UIButton) {
    }

    @IBAction private func didTapToChangeSlider(sender: UISlider) {
        player?.pause()
        if var time = player?.currentTime() {
            time.value = CMTimeValue(sender.value * Float(time.timescale))
            player?.seekToTime(time)
            player?.play()
        }
    }

    @IBAction private func didTapPlayButton(sender: UIButton) {
        playing = !playing
        if playing {
            playButton.setBackgroundImage(UIImage(assetIdentifier: .PauseWhite60), forState: .Normal)
            startRotate()
        } else {
            playButton.setBackgroundImage(UIImage(assetIdentifier: .PlayWhite60), forState: .Normal)
            stopRotate()
        }
        delegate?.didTapPlayButton(self)
    }

    @IBAction private func nextSong(sender: UIButton) {
    }

    @IBAction private func previousSong(sender: UIButton) {
    }
}
