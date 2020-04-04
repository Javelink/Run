//
//  TrainingDataStore.swift
//  RunApp
//
//  Created by Andrey Slota on 1/2/20.
//  Copyright © 2020 Andrey Slota. All rights reserved.
//

import HealthKit
import RunSiriCore

protocol HistoryUpdatable: class {
    func updateTableView(_ index: IndexPath)
}

final class TrainingDataStore {

    weak var delegate: HistoryUpdatable?

    func loadWorkouts(_ activityType: HKWorkoutActivityType, completion: @escaping ([HKWorkout]?, Error?) -> Void) {
        let workout = HKQuery.predicateForWorkouts(with: activityType)
        let source = HKQuery.predicateForObjects(from: .default())
        let compound = NSCompoundPredicate(andPredicateWithSubpredicates: [workout, source])

        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: true)

        let query = HKSampleQuery(sampleType: .workoutType(),
                                  predicate: compound,
                                  limit: 0,
                                  sortDescriptors: [sortDescriptor]) { query, samples, error in

            DispatchQueue.main.async {
                guard let samples = samples as? [HKWorkout], error == nil else {
                    completion(nil, error)
                    return
                }

                completion(samples, nil)
            }
        }

        HKHealthStore().execute(query)
    }

    func deleteTraining(_ workout: HKWorkout, for index: IndexPath) {
        let healthStore = HKHealthStore()

        healthStore.delete(workout) { [weak self] success, error in
            if success {
                self?.delegate?.updateTableView(index)
            }
        }
    }
}
