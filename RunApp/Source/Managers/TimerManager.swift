//
//  TimerManager.swift
//  RunApp
//
//  Created by Andrey Slota on 12/20/19.
//  Copyright © 2019 Andrey Slota. All rights reserved.
//

import Foundation

protocol TimerUpdateble {
    func updateTimeLabels(_ startTime: String, _ duretionTime: String)
    func updateSaveButtonStatus(_ isEnabled: Bool)
    func updateStartButtonStatus(_ isEnabled: Bool)
    func updateTitleStartStopButton(_ title: String)
}

public class TimerManager: NSObject {
    var timer: Timer = Timer()
    var delegate: TimerUpdateble?
    var session = TrainingSession()

    static var shared = TimerManager()

    public override init() {}

    private lazy var startTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }()

    private lazy var durationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = [.pad]
        return formatter
    }()

    func training(_ index: Int) {
        switch session.state {
        case .notStarted, .finished:
            beginTraining(index)
            delegate?.updateTitleStartStopButton("STOP")
        case .active:
            finishTraining()
            LocationManager.shared.stopUpdateLocation()
            delegate?.updateTitleStartStopButton("START")
        }
    }

    func beginTraining(_ index: Int) {
        switch index {
        case 0: session.start(.running)
        case 1: session.start(.walking)
        default: break
        }

        startTimer()
        updateButtonStatus()
    }

    func finishTraining() {
        session.end()
        self.updateLabels()
        self.updateButtonStatus()
    }

    func updateButtonStatus() {
        var isEnabled = false

        switch session.state {
        case .notStarted, .active:
            isEnabled = false
        case .finished:
            isEnabled = true
        }

        delegate?.updateSaveButtonStatus(isEnabled)
        delegate?.updateStartButtonStatus(!isEnabled)
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] _ in
            self?.updateLabels()
        }

        LocationManager.shared.startTreckLocation()
        LocationManager.shared.startUpdateLocation()
    }

    private func updateLabels() {
        let startTime = startTimeFormatter.string(from: session.startDate)

        switch session.state {
        case .active:
            let duration = Date().timeIntervalSince(session.startDate)
            delegate?.updateTimeLabels(startTime, durationFormatter.string(from: duration)!)
        case .finished:
            let duration = session.endDate.timeIntervalSince(session.startDate)
            delegate?.updateTimeLabels(startTime, durationFormatter.string(from: duration)!)
            LocationManager.shared.stopUpdateLocation()
        default:
            break
        }
    }
}
