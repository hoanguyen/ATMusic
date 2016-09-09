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
import MediaPlayer
import PageMenu

private let kTimerButtonSize = CGSize(width: 30, height: 30)

protocol DetailPlayerDataSource {
    func numberOfSongInPlaylist(viewController: UIViewController) -> Int?
    func songInPlaylist(viewController: UIViewController, atIndex index: Int) -> Song?
    func songNameList(viewController: UIViewController) -> [String]?
}

private extension Selector {
    static let tapToPause = #selector(DetailPlayerViewController.didTapPlayButton(_:))
    static let nextSong = #selector(DetailPlayerViewController.nextSong(_:))
    static let prevSong = #selector(DetailPlayerViewController.previousSong(_:))
    static let playFinish = #selector(DetailPlayerViewController.playerDidFinishPlaying(_:))
    static let showSongList = #selector(DetailPlayerViewController.showSongList(_:))
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
    @IBOutlet private weak var contentView: UIView!

    // MARK: - public property
    var dataSource: DetailPlayerDataSource?
    var player: AVPlayer?

    // MARK: - private property
    private var songIndex = 0
    private var song: Song?
    private var playlistName: String?
    private var currentRotateValue: CGFloat = 0.0
    private var isPlaying = true
    private var playBarButtonItem: UIBarButtonItem?
    private var prevBarButtonItem: UIBarButtonItem?
    private var nextBarButtonItem: UIBarButtonItem?
    private var moreBatButtonItem: UIBarButtonItem?
    private var isShuffle = false
    private var timeObserver: AnyObject?
    private var maxValue: Float = 0.0
    private var currentTime: Float = 0.0
    private var pageMenu: CAPSPageMenu?
    private var songListVC: SongListViewController?
    private var imageVC: ImageViewController?
    private var lyricVC: LyricViewController?

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
    convenience init(song: Song?, songIndex: Int, playlistName: String?) {
        self.init(nibName: "DetailPlayerViewController", bundle: nil)
        self.song = song
        self.songIndex = songIndex
        self.playlistName = playlistName
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - override func
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        imageVC?.startRotate()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        imageVC?.stopRotate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        playBarButtonItem = UIBarButtonItem(image: UIImage(assetIdentifier: .PauseBlack), style: .Plain, target: self, action: .tapToPause)
        moreBatButtonItem = UIBarButtonItem(image: UIImage(assetIdentifier: .MoreRed), style: .Plain, target: self, action: .showSongList)

        if UIScreen.mainScreen().traitCollection.userInterfaceIdiom == .Phone {
            prevBarButtonItem = UIBarButtonItem(image: UIImage(assetIdentifier: .PrevBlack), style: .Plain, target: self, action: .prevSong)
            nextBarButtonItem = UIBarButtonItem(image: UIImage(assetIdentifier: .NextBlack), style: .Plain, target: self, action: .nextSong)

            popupItem.leftBarButtonItems = [prevBarButtonItem ?? UIBarButtonItem(),
                playBarButtonItem ?? UIBarButtonItem(),
                nextBarButtonItem ?? UIBarButtonItem()]
            popupItem.rightBarButtonItems = [moreBatButtonItem ?? UIBarButtonItem()]
            popupBar?.leftBarButtonItems?.startIndex
        } else {
            popupItem.leftBarButtonItems = [playBarButtonItem ?? UIBarButtonItem()]
            popupItem.rightBarButtonItems = [moreBatButtonItem ?? UIBarButtonItem()]
        }
    }

    override func loadData() {
        super.loadData()
        dowloadSongWithID(song?.id) { (player) in
            self.player = player
            self.play()
            self.setupDuration()
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
        setupPageMenu()
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

    // MARK: - public func
    func getSongIndex() -> Int {
        return songIndex
    }

    func changeIndex(songIndex: Int) {
        self.songIndex = songIndex
    }

    func currentSongID() -> Int? {
        return song?.id
    }

    func pause() {
        isPlaying = false
        kNotification.removeObserver(self, name: AVPlayerItemDidPlayToEndTimeNotification, object: nil)
        player?.pause()
        playBarButtonItem?.image = UIImage(assetIdentifier: .PlayBlack)
        playButton.setBackgroundImage(UIImage(assetIdentifier: .PlayWhite60), forState: .Normal)
        imageVC?.stopRotate()
    }

    func play() {
        isPlaying = true
        kNotification.addObserver(self,
            selector: .playFinish, name: AVPlayerItemDidPlayToEndTimeNotification, object: nil)
        player?.play()
        playBarButtonItem?.image = UIImage(assetIdentifier: .PauseBlack)
        playButton.setBackgroundImage(UIImage(assetIdentifier: .PauseWhite60), forState: .Normal)
        imageVC?.startRotate()
    }

    func nextSong() -> Bool {
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

    func previousSong() {
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

    func reloadWhenChangeSongList() {
        songListVC?.reloadWhenChangeSongList(dataSource?.songNameList(self))
    }

    // MARK: - private Actions
    @IBAction func didTapTimerButton(sender: UIButton) {
        kAppDelegate?.timerVC = TimerViewController()
        if let timerVC = kAppDelegate?.timerVC {
            presentViewController(timerVC, animated: true, completion: nil)
        }
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
        isPlaying ? pause() : play()
    }

    @IBAction @objc private func nextSong(sender: UIButton) {
        sender.enabled = false
        nextSong()
        Helper.delay(second: 1) {
            sender.enabled = true
        }
    }

    @IBAction @objc private func previousSong(sender: UIButton) {
        sender.enabled = false
        previousSong()
        Helper.delay(second: 1) {
            sender.enabled = true
        }
    }

    @IBAction @objc private func showSongList(sender: UIButton) {
    }
}

// MARK: - DetailPlayVC extension for private func
extension DetailPlayerViewController {
    private func setupPageMenu() {
        if let songNameList = dataSource?.songNameList(self) {
            songListVC = SongListViewController(songNameList: songNameList,
                playAtIndex: songIndex, playlistName: playlistName)
        } else {
            songListVC = SongListViewController.vc()
        }
        songListVC?.delegate = self
        imageVC = ImageViewController(imageURLString: song?.urlImage)
        lyricVC = LyricViewController.vc()
        let arrayVC: [UIViewController] = [songListVC ?? UIViewController(), imageVC ?? UIViewController(), lyricVC ?? UIViewController()]
        let parameters: [CAPSPageMenuOption] = [
                .MenuItemSeparatorWidth(4.3),
                .UseMenuLikeSegmentedControl(true),
                .MenuItemSeparatorPercentageHeight(0.1),
                .HideTopMenuBar(true)
        ]
        pageMenu = CAPSPageMenu(viewControllers: arrayVC,
            frame: contentView.bounds,
            pageMenuOptions: parameters)
        if let view = pageMenu?.view {
            contentView.addSubview(view)
        }
        pageMenu?.moveToPage(1) // focus on ImageVC
        pageMenu?.view.backgroundColor = UIColor.clearColor()
        songListVC?.view.backgroundColor = UIColor.clearColor()
        imageVC?.view.backgroundColor = UIColor.clearColor()
        lyricVC?.view.backgroundColor = UIColor.clearColor()
    }

    private func setupArtWorkInfo() {
        let nowPlayingInfo: [String: AnyObject] = [
            MPMediaItemPropertyArtist: song?.singerName ?? "",
            MPMediaItemPropertyTitle: song?.songName ?? "",
            MPMediaItemPropertyPlaybackDuration: maxValue,
            MPNowPlayingInfoPropertyElapsedPlaybackTime: currentTime,
            MPNowPlayingInfoPropertyPlaybackRate: isPlaying ? 1.0 : 0.0
        ]
        MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo?.removeAll()
        MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo = nowPlayingInfo
    }

    private func dowloadSongWithID(id: Int?, complitionHandler finished: DowloadSongFinished) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            if let url = Strings.getMusicStreamURL(id) {
                let player = AVPlayer(URL: url)
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                dispatch_async(dispatch_get_main_queue()) {
                    finished(player: player)
                }
            }
        }
    }

    private func reLoadDataAndUI() {
        loadData()
        setupImage()
        setupLabel()
        setupArtWorkInfo()
        songListVC?.highlightCellAtIndex(songIndex)
    }

    private func updateCurrentPlayTime() {
        let interval = CMTimeMakeWithSeconds(1.0, 1)
        timeObserver = player?.addPeriodicTimeObserverForInterval(interval, queue: nil, usingBlock: { (cmTime) in
            self.updateChangeForLabel(self.convertToSecond(cmTime))
        })
    }

    private func convertToSecond(time: CMTime?) -> Int? {
        guard let time = time else { return nil }
        return Int(CMTimeGetSeconds(time))
    }

    private func updateChangeForLabel(second: Int?) {
        guard let second = second else { return }
        currentTime = Float(second)
        currentDurationLabel.text = second.convertToMinute()
        durationSlider.value = currentTime
        setupArtWorkInfo()
        popupItem.progress = currentTime / maxValue
    }

    private func setupDuration() {
        if let duration = player?.currentItem?.asset.duration, second = convertToSecond(duration) {
            restDurationLabel.text = second.convertToMinute()
            durationSlider.maximumValue = Float(second)
            maxValue = Float(second)
        }
        updateCurrentPlayTime()
    }

    private func setupLabel() {
        songTitle = song?.songName ?? ""
        albumTitle = song?.singerName ?? ""
        currentDurationLabel.font = HelveticaFont().Regular(11)
        singerNameLabel.font = HelveticaFont().Regular(11)
        restDurationLabel.font = HelveticaFont().Regular(11)
        songNameLabel.font = HelveticaFont().Regular(15)
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
        if let imageURLString = song?.urlImage, url = NSURL(string: imageURLString) {
            backgroundImageView.sd_setImageWithURL(url)
        }
        imageVC?.reloadImage(song?.urlImage)
    }

    private func reloadSong() {
        if let timeObserver = timeObserver {
            player?.removeTimeObserver(timeObserver)
        }
        pause()
        durationSlider.value = 0
        currentDurationLabel.text = "0:00"
        maxValue = 0
        currentTime = 0
        if let song = dataSource?.songInPlaylist(self, atIndex: (songIndex)) {
            player = nil
            self.song = song
            reLoadDataAndUI()
        }
    }

    private func randomSong() {
        if let count = dataSource?.numberOfSongInPlaylist(self) {
            let rand = Int(arc4random_uniform(UInt32(count)))
            if songIndex != rand {
                songIndex = rand
                reloadSong()
                return
            }
            randomSong()
        }

    }

    @objc private func playerDidFinishPlaying(sender: NSNotification) {
        kNotification.removeObserver(self, name: AVPlayerItemDidPlayToEndTimeNotification, object: nil)
        player?.seekToTime(kCMTimeZero)
        pause()
        if let repeating = kAppDelegate?.repeating {
            switch repeating {
            case .None:
                if !nextSong() {
                    isPlaying = false
                    pause()
                }
            case .One:
                player?.seekToTime(kCMTimeZero)
                player?.play()
                play()
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

// MARK: - SongList Delegate
extension DetailPlayerViewController: SongListControllerDelegate {
    func songListViewController(viewController: UIViewController, didSelectSongAtIndex index: Int) {
        songIndex = index
        player?.cancelPendingPrerolls()
        reloadSong()
    }
}
