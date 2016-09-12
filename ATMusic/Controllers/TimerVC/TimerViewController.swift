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
    // MARK: - private Outlet
    @IBOutlet private weak var restTimeLabel: UILabel!
    @IBOutlet private weak var pickerTimer: UIPickerView!
    @IBOutlet private weak var pauseButton: UIButton!
    @IBOutlet private weak var startButton: UIButton!
    @IBOutlet private weak var startView: UIView!
    @IBOutlet private weak var pauseView: UIView!

    // MARK: - private property
    private var hours: [Int] = [Int]()
    private var minutes: [Int] = [Int]()
    private var currentHourRow = 0
    private var currentMinuteRow = 1

    // MARK: - override func
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
    }

    override func configUI() {
        super.configUI()
        startView.circle()
        startView.clipsToBounds = true
        pauseView.circle()
        pauseView.clipsToBounds = true
        if let isCounting = kAppDelegate?.isCounting where isCounting {
            if let isPause = kAppDelegate?.isPause where isPause {
                setupWhenTimerPause()
            } else {
                setupWhenTimerIsRunning()
            }
        } else {
            setupWhenTimerDidStop()
        }
    }

    // MARK: - public func
    func setupTime() {
        for i in 0...kMaxMinute {
            if i <= kMaxHour {
                hours.append(i)
            }
            minutes.append(i)
        }
    }

    func setupWhenTimerDidStop() {
        invalidateTimer()
        kAppDelegate?.isCounting = false
        kAppDelegate?.isPause = false
        kAppDelegate?.timer = nil
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

    // MARK: - private Action
    @IBAction private func didTapPauseButton(sender: UIButton) {
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

    @IBAction private func didTapStartButton(sender: UIButton) {
        if let isCounting = kAppDelegate?.isCounting {
            kAppDelegate?.isCounting = !isCounting
            if isCounting {
                setupWhenTimerDidStop()
                kAppDelegate?.isCounting = false
            } else {
                setupWhenTimerIsRunning()
                startCounter()
            }
        }
    }

    @IBAction private func didTapDismisButton(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - private func
    private func setupWhenTimerPause() {
        pauseButton.setTitle(Strings.Resume, forState: .Normal)
        pauseView.backgroundColor = .whiteColor()
        startButton.setTitle(Strings.Cancel, forState: .Normal)
        startButton.setTitleColor(Color.Red225, forState: .Normal)
        reloadTitleForRestTimeLabel()
        pauseButton.enabled = true
        pickerTimer.hidden = true
        restTimeLabel.hidden = false
    }

    private func invalidateTimer() {
        kAppDelegate?.timer?.invalidate()
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

    private func setDefaultForPickerView() {
        currentMinuteRow = 1
        pickerTimer.selectRow(currentMinuteRow, inComponent: 2, animated: true)
    }
}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension TimerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 4 // ex: "5" "hours" "1" "min" = 4 component
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return hours.count
        case 2:
            return minutes.count
        default:
            return 1 // just show one line is hour or min
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
            label.font = HelveticaFont().Regular(14)
            return label
        case 2:
            label.text = "\(minutes[row])"
            label.textAlignment = .Right
            label.font = HelveticaFont().Regular(19)
            return label
        default:
            label.text = "min"
            label.textAlignment = .Left
            label.font = HelveticaFont().Regular(14)
            return label
        }
    }

    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            currentHourRow = row
            pickerView.reloadComponent(1) // "hour" : "hours" change between them.
        case 2:
            currentMinuteRow = row
            if currentHourRow == 0 && currentMinuteRow == 0 { // minimum of Timer is 1 min, can not assign 0 hour 0 min
                setDefaultForPickerView()
            }
        default:
            break
        }
    }
}
