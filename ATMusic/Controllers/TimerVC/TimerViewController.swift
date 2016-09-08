//
//  TimerViewViewController.swift
//  ATMusic
//
//  Created by Nguyen Thanh Su on 8/31/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit

private let kMaxHour = 23
private let kMaxMinute = 59
private let kNormalRow: CGFloat = 25.0
private let kWidthHourRow: CGFloat = 50.0
private let kWidthMinuteRow: CGFloat = 80.0

class TimerViewController: BaseVC {
    @IBOutlet weak var restTimeLabel: UILabel!
    @IBOutlet weak var pickerTimer: UIPickerView!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var startView: UIView!
    @IBOutlet weak var pauseView: UIView!

    private var hours = [Int]()
    private var minutes = [Int]()
    private var currentHourRow = 0
    private var currentMinuteRow = 1

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillLayoutSubviews() {
        startView.circle()
        startView.clipsToBounds = true
        pauseView.circle()
        pauseView.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func loadData() {
        super.loadData()
        setupTime()
        setDefaultForPickerView()
        if let isCounting = kAppDelegate?.isCounting where isCounting {
            setupWhenTimerIsRunning()
        } else {
            setupWhenTimerDidStop()
        }
    }

    override func configUI() {
        super.configUI()
        startView.circle()
        startView.clipsToBounds = true
        pauseView.circle()
        pauseView.clipsToBounds = true
    }

    func setupTime() {
        for i in 0...kMaxMinute {
            if i <= kMaxHour {
                hours.append(i)
            }
            minutes.append(i)
        }
    }

    // MARK: - private outlet
    @IBAction func didTapPauseButton(sender: UIButton) {
        if let isPause = kAppDelegate?.isPause {
            kAppDelegate?.isPause = !isPause
            if isPause {
                pauseButton.setTitle(Strings.Pause, forState: .Normal)
                kAppDelegate?.setupTimer()
            } else {
                invalidateTimer()
                pauseButton.setTitle(Strings.Resume, forState: .Normal)
            }
        }
    }

    @IBAction func didTapStartButton(sender: UIButton) {
        if let isCounting = kAppDelegate?.isCounting {
            kAppDelegate?.isCounting = !isCounting
            if isCounting {
                setupWhenTimerDidStop()
                kAppDelegate?.isCounting = false
                invalidateTimer()
            } else {
                setupWhenTimerIsRunning()
                startCounter()
            }
        }
    }

    @IBAction func didTapDismisButton(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    private func invalidateTimer() {
        kAppDelegate?.timer?.invalidate()
    }

    private func setupWhenTimerDidStop() {
        startButton.setTitle(Strings.Start, forState: .Normal)
        startButton.setTitleColor(Color.Green175, forState: .Normal)
        pauseButton.setTitle(Strings.Pause, forState: .Normal)
        pauseButton.setTitleColor(Color.White69, forState: .Normal)
        pauseView.backgroundColor = Color.White178
        pauseButton.enabled = false
        pickerTimer.hidden = false
        restTimeLabel.hidden = true
        restTimeLabel.text = ""
    }

    private func setupWhenTimerIsRunning() {
        startButton.setTitle(Strings.Cancel, forState: .Normal)
        startButton.setTitleColor(Color.Red225, forState: .Normal)
        pauseButton.enabled = true
        pauseButton.setTitleColor(.blackColor(), forState: .Normal)
        pauseView.backgroundColor = .whiteColor()
        pickerTimer.hidden = true
        restTimeLabel.hidden = false
    }

    private func startCounter() {
        kAppDelegate?.restCounter = currentHourRow * 60 * 60 + currentMinuteRow * 60
        kAppDelegate?.setupTimer()
    }

    func reloadTitleForRestTimeLabel() {
        if let restCounter = kAppDelegate?.restCounter {
            let hour = restCounter / 3600
            let minute = restCounter % 3600 / 60
            let second = restCounter % 3600 % 60
            let hourString = hour > 0 ? (hour >= 10 ? "\(hour) : " : "0\(hour) : ") : ""
            let minuteString = minute >= 10 ? "\(minute) : " : "0\(minute) : "
            let secondString = second >= 10 ? "\(second)" : "0\(second)"
            restTimeLabel.text = hourString + minuteString + secondString
        }
    }

    private func setDefaultForPickerView() {
        currentMinuteRow = 1
        pickerTimer.selectRow(currentMinuteRow, inComponent: 2, animated: true)
    }
}

extension TimerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 4
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return hours.count
        case 1:
            return 1
        case 2:
            return minutes.count
        default:
            return 1
        }
    }

    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        switch component {
        case 1:
            return kWidthHourRow
        case 3:
            return kWidthHourRow
        default:
            return kNormalRow
        }
    }

    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let label = UILabel()
        switch component {
        case 0:
            label.text = "\(hours[row])"
            label.textAlignment = .Right
            label.font = HelveticaFont().Regular(19)
            return label
        case 1:
            label.text = currentHourRow == 1 ? "hour" : "hours"
            label.textAlignment = .Left
            label.font = HelveticaFont().Regular(13)
            return label
        case 2:
            label.text = "\(minutes[row])"
            label.textAlignment = .Right
            label.font = HelveticaFont().Regular(19)
            return label
        default:
            label.text = "min"
            label.textAlignment = .Left
            label.font = HelveticaFont().Regular(13)
            return label
        }
    }

    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            currentHourRow = row
            pickerView.reloadComponent(1)
        case 2:
            currentMinuteRow = row
            if currentHourRow == 0 && currentMinuteRow == 0 {
                setDefaultForPickerView()
            }
        default:
            break
        }
    }
}
