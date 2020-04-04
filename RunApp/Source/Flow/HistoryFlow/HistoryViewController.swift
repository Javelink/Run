//
//  HistoryViewController.swift
//  RunApp
//
//  Created by Andrey Slota on 1/2/20.
//  Copyright © 2020 Andrey Slota. All rights reserved.
//

import UIKit
import HealthKit

final class HistoryViewController: UIViewController {

    // MARK: - Properties
    private var workouts: [HKWorkout]?
    private var trainingDataStore = TrainingDataStore()

    @IBOutlet private weak var chooseLoad: UISegmentedControl!
    @IBOutlet private weak var tableView: UITableView!

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .medium
        return formatter
    }()

    // MARK: - Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        trainingDataStore.delegate = self
        navigationController?.setupNavigationStyle()
        tabBarController?.tabBar.tintColor = .purple
        tableView.tableFooterView = UIView(frame: .zero)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadWorkouts()
    }

    // MARK: - Actions
    @IBAction private func loadHistoryTraining(_ sender: UISegmentedControl) {
        reloadWorkouts()
    }

    // MARK: - Private Func
    private func reloadWorkouts() {
        switch chooseLoad.selectedSegmentIndex {
        case 0: loadWorkout(.running)
        case 1: loadWorkout(.walking)
        default: break
        }
    }

    private func loadWorkout(_ activityType: HKWorkoutActivityType) {
        trainingDataStore.loadWorkouts(activityType) { [weak self] workouts, error in
            self?.workouts = workouts
            self?.tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workouts?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let workouts = workouts?[indexPath.row],
            let caloriesBurned = workouts.totalEnergyBurned?.doubleValue(for: .kilocalorie()) else {
            fatalError("no workouts")
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath)
        let formattedCalories = String(format: "Calories Burned: %.2f", caloriesBurned)

        cell.textLabel?.text = dateFormatter.string(from: workouts.startDate)
        cell.detailTextLabel?.text = formattedCalories

        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let workout = workouts?[indexPath.row] else { return }
        trainingDataStore.deleteTraining(workout, for: indexPath)
    }
}

// MARK: - HistoryUpdatable
extension HistoryViewController: HistoryUpdatable {
    func updateTableView(_ index: IndexPath) {
        workouts?.remove(at: index.row)
        DispatchQueue.main.async {
            self.tableView.deleteRows(at: [index], with: .automatic)
        }
    }
}
