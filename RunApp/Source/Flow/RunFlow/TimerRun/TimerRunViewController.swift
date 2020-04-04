//
//  TimerRunViewController.swift
//  RunApp
//
//  Created by Andrey Slota on 12/20/19.
//  Copyright © 2019 Andrey Slota. All rights reserved.
//

import UIKit
import HealthKit
import RunSiriCore

final class TimerRunViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet private weak var startTimeLabel: UILabel!
    @IBOutlet private weak var timerLabel: UILabel!
    @IBOutlet private weak var metersLabel: UILabel!
    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet private weak var startButton: UIButton!

    private let healthManager = HealthKitManager()
    private var trainingDataStore = TrainingDataStore()
    private var trainingService = TrainingSession()
    private let timerManager = TimerManager.shared
    var index: Int?

    // MARK: - Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        timerManager.delegate = self
        LocationManager.shared.distanceDelegate = self
        LocationManager.shared.setupLocationManager()
        timerManager.training(index!)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
        timerManager.updateButtonStatus()
    }

    // MARK: - Actions
    @IBAction private func onSave(_ sender: UIButton) {
        switch index {
        case 0: save(.running)
        case 1: save(.walking)
        default: break
        }
    }

    @IBAction private func onStart(_ sender: UIButton) {
        timerManager.training(index!)
    }

    // MARK: - Private Func
    private func save(_ activityType: HKWorkoutActivityType) {
        guard let currentWorkout = timerManager.session.completeWorkout else { return }

        trainingService.save(training: currentWorkout, activityType: activityType) { [weak self] success, error in
            guard success == true, error == nil else { return }

            DispatchQueue.main.async { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
}

// MARK: - TimerUpdateble
extension TimerRunViewController: TimerUpdateble {
    func updateTimeLabels(_ startTime: String, _ duretionTime: String) {
        startTimeLabel.text = startTime
        timerLabel.text = duretionTime
    }

    func updateSaveButtonStatus(_ isEnabled: Bool) {
        saveButton.isEnabled = isEnabled
    }

    func updateStartButtonStatus(_ isEnabled: Bool) {
        startButton.isEnabled = isEnabled
    }

    func updateTitleStartStopButton(_ title: String) {
        startButton.setTitle(title, for: .normal)
    }
}

// MARK: - DistanceUpdatable
extension TimerRunViewController: DistanceUpdatable {
    func updateDistance(_ distance: String) {
        metersLabel.text = distance
    }
}
