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
import LNPopupController

protocol DetailPlayerDelegate {
    func detailPlayer(viewController: UIViewController, changeToSongAtIndex index: Int)
}

protocol DetailPlayerDataSource {
    func numberOfSongInPlaylist(viewController: UIViewController) -> Int?
    func songInPlaylist(viewController: UIViewController, atIndex index: Int) -> Song?
}

private extension Selector {
    static let tapToPause = #selector(DetailPlayerViewController.didTapPlayButton(_:))
    static let nextSong = #selector(DetailPlayerViewController.nextSong(_:))
    static let prevSong = #selector(DetailPlayerViewController.previousSong(_:))
}

typealias DowloadSongFinished = (player: AVPlayer) -> Void

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
    var dataSource: DetailPlayerDataSource?
    var player: AVPlayer?

    // MARK: - private property
    private var songIndex = 0
    private var song: Song?
    private var currentRotateValue: CGFloat = 0.0
    private var playing = true
    private var playBarButtonItem: UIBarButtonItem?
    private var prevBarButtonItem: UIBarButtonItem?
    private var nextBarButtonItem: UIBarButtonItem?
    private var isShuffle = false
    private var timeObserver: AnyObject?
    private var maxValue: Float = 0.0

    private var songTitle: String = "" {
        didSet {
            if isViewLoaded() {
                songNameLabel.text = songTitle
            }

            popupItem.title = songTitle
        }
    }
    private var albumTitle: String = "" {
        didSet {
            if isViewLoaded() {
                singerNameLabel.text = albumTitle
            }
            popupItem.subtitle = albumTitle
        }
    }
    // MARK: - init func
    convenience init(song: Song?, songIndex: Int) {
        self.init(nibName: "DetailPlayerViewController", bundle: nil)
        self.song = song
        self.songIndex = songIndex
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - override func
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidLayoutSubviews() {
        imageAvatar.circle()
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

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        playBarButtonItem = UIBarButtonItem(image: UIImage(assetIdentifier: .PauseBlack), style: .Plain, target: self, action: .tapToPause)

        if UIScreen.mainScreen().traitCollection.userInterfaceIdiom == .Phone {
            prevBarButtonItem = UIBarButtonItem(image: UIImage(assetIdentifier: .PrevBlack), style: .Plain, target: self, action: .prevSong)
            nextBarButtonItem = UIBarButtonItem(image: UIImage(assetIdentifier: .NextBlack), style: .Plain, target: self, action: .nextSong)

            popupItem.leftBarButtonItems = [prevBarButtonItem!, playBarButtonItem!, nextBarButtonItem!]
            popupBar?.leftBarButtonItems?.startIndex
//            popupBar?.popupItem?.rightBarButtonItems = [list, more]
        } else {
            popupItem.leftBarButtonItems = [playBarButtonItem!]
//            popupItem.rightBarButtonItems = [more]
        }
    }

    override func loadData() {
        super.loadData()
        dowloadSongWithID(song?.id) { (player) in
            self.player = player
            self.player?.play()
            NSNotificationCenter.defaultCenter().addObserver(self,
                selector: #selector(self.playerDidFinishPlaying(_:)), name: AVPlayerItemDidPlayToEndTimeNotification, object: nil)
        }
    }

    private func dowloadSongWithID(id: Int?, complitionHandler finished: DowloadSongFinished) {
        if let url = Strings.getMusicStreamURL(id) {
            let player = AVPlayer(URL: url)
            finished(player: player)
        }
    }

    override func configUI() {
        if let _ = song {
            super.configUI()
            setupImage()
            // create blur view
            let blurView = View.createPlayerBlurView(frame: view.bounds)
            view.addSubview(blurView)
            view.bringSubviewToFront(mainView)
            view.tintColor = UIColor.whiteColor()
            setupLabel()
        }
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .Default
    }

    // MARK: - public func
    func currentSongID() -> Int? {
        return song?.id
    }

    // MARK: - private Actions
    @IBAction private func didTapButtonMore(sender: UIButton) {
    }

    @IBAction private func addToFavourite(sender: UIButton) {
    }

    @IBAction private func changeRepeatMode(sender: UIButton) {
        if let repeating = kAppDelegate?.repeating {
            switch repeating {
            case .None:
                kAppDelegate?.repeating = .One
                repeatButton.setBackgroundImage(UIImage(assetIdentifier: .RepeatOneRed30), forState: .Normal)
            case .One:
                kAppDelegate?.repeating = .All
                repeatButton.setBackgroundImage(UIImage(assetIdentifier: .RepeatAllRed30), forState: .Normal)
            case .All:
                kAppDelegate?.repeating = .None
                repeatButton.setBackgroundImage(UIImage(assetIdentifier: .RepeatOffWhite30), forState: .Normal)
            }
        }
    }

    @IBAction private func changeShuffleMode(sender: UIButton) {
        isShuffle = !isShuffle
        setupShuffleButtonImage()
    }

    @IBAction private func didTapToChangeSlider(sender: UISlider) {
        pause()
        if var time = player?.currentTime() {
            time.value = CMTimeValue(sender.value * Float(time.timescale))
            player?.seekToTime(time)
            play()
        }
    }

    @IBAction @objc private func didTapPlayButton(sender: UIButton) {
        if playing {
            pause()
        } else {
            play()
        }
    }

    @IBAction @objc private func nextSong(sender: UIButton) {
        nextSong()
    }

    @IBAction @objc private func previousSong(sender: UIButton) {
        if isShuffle {
            randomSong()
        } else {
            if let songCount = dataSource?.numberOfSongInPlaylist(self) where (songIndex - 1) >= 0 {
                if songIndex > songCount {
                    songIndex = songCount
                }
                songIndex = songIndex - 1
                reloadSong()
            }
        }
    }
}

extension DetailPlayerViewController {
    // MARK: - private func
    private func reLoadDataAndUI() {
        loadData()
        setupImage()
        setupLabel()
    }

    private func updateCurrentPlayTime() {
        let interval = CMTimeMakeWithSeconds(1.0, 1)
        timeObserver = player?.addPeriodicTimeObserverForInterval(interval, queue: nil, usingBlock: { (cmTime) in
            self.updateChangeForLabel(self.convertToSecond(cmTime), maxValue: self.maxValue)
        })
    }

    private func convertToSecond(time: CMTime?) -> Int? {
        guard let time = time else { return nil }
        return Int(CMTimeGetSeconds(time))
    }

    private func updateChangeForLabel(second: Int?, maxValue: Float) {
        guard let second = second else { return }
        self.currentDurationLabel.text = second.convertToMinute()
        self.durationSlider.value = Float(second)
        popupItem.progress = Float(second) / maxValue
    }

    private func setupLabel() {
        songTitle = song?.songName ?? ""
        albumTitle = song?.singerName ?? ""
        currentDurationLabel.font = HelveticaFont().Regular(11)
        singerNameLabel.font = HelveticaFont().Regular(11)
        restDurationLabel.font = HelveticaFont().Regular(11)
        songNameLabel.font = HelveticaFont().Regular(15)
        if let duration = player?.currentItem?.asset.duration, let second = convertToSecond(duration) {
            restDurationLabel.text = second.convertToMinute()
            durationSlider.maximumValue = Float(second)
            maxValue = Float(second)
        }
        updateCurrentPlayTime()
    }

    private func setupImage() {
        setupAvatarImage()
        setupRepeatButtonImage()
        setupRepeatButtonImage()
        setupShuffleButtonImage()
    }

    private func setupShuffleButtonImage() {
        if isShuffle {
            shuffleButton.setBackgroundImage(UIImage(assetIdentifier: .ShuffleRed30), forState: .Normal)
        } else {
            shuffleButton.setBackgroundImage(UIImage(assetIdentifier: .ShuffleWhite30), forState: .Normal)
        }
    }

    private func setupRepeatButtonImage() {
        if let repeating = kAppDelegate?.repeating {
            switch repeating {
            case .None:
                repeatButton.setBackgroundImage(UIImage(assetIdentifier: .RepeatOffWhite30), forState: .Normal)
            case .One:
                repeatButton.setBackgroundImage(UIImage(assetIdentifier: .RepeatOneRed30), forState: .Normal)
            case .All:
                repeatButton.setBackgroundImage(UIImage(assetIdentifier: .RepeatAllRed30), forState: .Normal)
            }
        } else {
            kAppDelegate?.repeating = .None
            repeatButton.setBackgroundImage(UIImage(assetIdentifier: .RepeatOffWhite30), forState: .Normal)
        }
    }

    private func setupAvatarImage() {
        if let imageURLString = song?.urlImage, let url = NSURL(string: imageURLString) {
            backgroundImageView.sd_setImageWithURL(url)
            imageAvatar.sd_setImageWithURL(url)
            imageAvatar.circle()
            imageAvatar.clipsToBounds = true
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

    private func pause() {
        playing = false
        NSNotificationCenter.defaultCenter().removeObserver(self, name: AVPlayerItemDidPlayToEndTimeNotification, object: nil)
        player?.pause()
        playBarButtonItem?.image = UIImage(assetIdentifier: .PlayBlack)
        playButton.setBackgroundImage(UIImage(assetIdentifier: .PlayWhite60), forState: .Normal)
        stopRotate()
    }

    private func play() {
        playing = true
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: #selector(self.playerDidFinishPlaying(_:)), name: AVPlayerItemDidPlayToEndTimeNotification, object: nil)
        player?.play()
        playBarButtonItem?.image = UIImage(assetIdentifier: .PauseBlack)
        playButton.setBackgroundImage(UIImage(assetIdentifier: .PauseWhite60), forState: .Normal)
        startRotate()
    }

    private func reloadSong() {
        if let timeObserver = timeObserver {
            player?.removeTimeObserver(timeObserver)
        }
        durationSlider.value = 0
        currentDurationLabel.text = "0:00"
        if let song = dataSource?.songInPlaylist(self, atIndex: (songIndex)) {
            player = nil
            self.song = song
            reLoadDataAndUI()
        }
    }

    private func randomSong() {
        if let count = dataSource?.numberOfSongInPlaylist(self) {
            songIndex = Int(arc4random_uniform(UInt32(count)))
            reloadSong()
        }

    }

    private func nextSong() -> Bool {
        if isShuffle {
            randomSong()
            return true
        } else {
            if let songCount = dataSource?.numberOfSongInPlaylist(self) where (songIndex + 1) < songCount {
                songIndex = songIndex + 1
                player?.cancelPendingPrerolls()
                reloadSong()
                return true
            }
        }
        return false
    }

    @objc private func playerDidFinishPlaying(sender: NSNotification) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: AVPlayerItemDidPlayToEndTimeNotification, object: nil)
        player?.seekToTime(kCMTimeZero)
        player?.pause()
        if let repeating = kAppDelegate?.repeating {
            switch repeating {
            case .None:
                if !nextSong() {
                    playing = false
                    pause()
                }
            case .One:
                player?.seekToTime(kCMTimeZero)
                player?.play()
            case .All:
                if !nextSong() {
                    songIndex = -1
                    nextSong()
                }
            }
        }
        updateCurrentPlayTime()
    }
}
