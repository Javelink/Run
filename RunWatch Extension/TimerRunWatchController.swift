//
//  TimerRunWatchController.swift
//  RunWatch Extension
//
//  Created by Andrey Slota on 1/16/20.
//  Copyright © 2020 Andrey Slota. All rights reserved.
//

import WatchKit
import HealthKit

final class TimerRunWatchController: WKInterfaceController {

    @IBOutlet private weak var timeLabel: WKInterfaceLabel!
    @IBOutlet private weak var stepLabel: WKInterfaceLabel!
    @IBOutlet private weak var saveButton: WKInterfaceButton!
    @IBOutlet private weak var stopButton: WKInterfaceButton!

    private var session = TrainingSession()
    private let timerManager = TimerManager.shared
    private let locationManager = LocationManager.shared
    private var index: Int!

    //MARK: - Life Cycle
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        timerManager.delegate = self
        locationManager.watchUpdate = self
        stopButton.setTitle("Start")
        timerManager.training(context as! Int)
        index = context as? Int
    }

    @IBAction func onSave() {
        switch index {
        case 0: save(.running)
        case 1: save(.walking)
        default: break
        }
    }

    @IBAction func onStartStop() {
        switch timerManager.session.state {
        case .notStarted, .finished:
            timerManager.training(index)
            stopButton.setTitle("Stop")
        case .active:
            timerManager.finishTraining()
            stopButton.setTitle("Start")
        }
    }

    private func save(_ activityType: HKWorkoutActivityType) {
        guard let currentWorkout = timerManager.session.completeWorkout else { return }

        timerManager.session.save(training: currentWorkout, activityType: activityType) { [weak self] success, error in
            guard success == true, error == nil else { return }

            DispatchQueue.main.async { [weak self] in
                self?.pushController(withName: "InterfaceController", context: nil)
            }
        }
    }
}

extension TimerRunWatchController: DistanceWatchUpdatable, TimerUpdateble {
    func updateTimeLabels(_ startTime: String, _ duretionTime: String) {
        timeLabel.setText(duretionTime)
    }

    func updateSaveButtonStatus(_ isEnabled: Bool) {
        saveButton.setEnabled(isEnabled)
    }

    func updateStartButtonStatus(_ isEnabled: Bool) {
        stopButton.setEnabled(isEnabled)
    }

    func updateTitleStartStopButton(_ title: String) {
        stopButton.setTitle(title)
    }

    func updateDistance(_ distance: String) {
        stepLabel.setText(distance)
    }
}
