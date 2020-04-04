//
//  TrainingSession.swift
//  RunApp
//
//  Created by Andrey Slota on 1/2/20.
//  Copyright © 2020 Andrey Slota. All rights reserved.
//

import Foundation
import Intents
import HealthKit

public struct TrainingSession {
    public var startDate: Date!
    public var endDate: Date!

    public var intervals: [TrainingInterval] = []
    public var state: Training.TrainingSessionState = .notStarted
    public var kind: HKWorkoutActivityType = .running
    
    static public var shared = TrainingSession()

    public init() {}
    
    public mutating func start(_ kind: HKWorkoutActivityType) {
        self.startDate = Date()
        self.state = .active
        self.kind = kind
    }

    public mutating func end() {
        endDate = Date()
        addNewInterval()
        state = .finished
    }

    public mutating func startWorkout(_ workoutName: INSpeakableString) {
        switch Training.TrainingKind(intentWorkoutName: workoutName) {
        case .running: start(.running)
        case .walking: start(.walking)
        default: break
        }
    }

    public mutating func clear() {
        startDate = nil
        endDate = nil
        state = .notStarted
        intervals.removeAll()
    }

    public  mutating func addNewInterval() {
        let interval = TrainingInterval(start: startDate, end: endDate)
        intervals.append(interval)
    }

    public var completeWorkout: Training? {
        guard state == .finished, intervals.count > 0 else { return nil }
        return Training(intervals)
    }

    public func save(_ workoutName: INSpeakableString) {
        switch Training.TrainingKind(intentWorkoutName: workoutName) {
        case .running: saveWorkout(.running)
        case .walking: saveWorkout(.walking)
        default: break
        }
    }

    public func saveWorkout(_ activityType: HKWorkoutActivityType) {

        guard let workout = completeWorkout else { return }

        save(training: workout, activityType: activityType) { success, error in
            guard error != nil else { return }
        }
    }

    public func save(training: Training, activityType: HKWorkoutActivityType, completion: @escaping ((Bool, Error?) -> Void)) {

        let healthStore = HKHealthStore()
        let workoutConfiguration = HKWorkoutConfiguration()
        workoutConfiguration.activityType = activityType
        let samples = TrainingSession.self.samples(for: training)

        let builder = HKWorkoutBuilder(healthStore: healthStore,
                                       configuration: workoutConfiguration,
                                       device: .local())

        builder.beginCollection(withStart: training.start) { success, error in
            guard success else {
                completion(false, error)
                return
            }

            builder.add(samples) { success, error in
                guard success else {
                    completion(false, error)
                    return
                }

                builder.endCollection(withEnd: training.end) { success, error in
                    guard success else {
                        completion(false, error)
                        return
                    }

                    builder.finishWorkout { workout, error in
                        let success = error == nil
                        completion(success, error)
                    }
                }
            }
        }
    }

    private static func samples(for workout: Training) -> [HKSample] {
           guard let energyQuantityType = HKSampleType.quantityType(forIdentifier: .activeEnergyBurned) else {
               fatalError("fatalError")
           }

           let samples: [HKSample] = workout.intervals.map { interval in
               let calorieQuantity = HKQuantity(unit: .kilocalorie(), doubleValue: interval.totalEnergyBurned)

               return HKCumulativeQuantitySample(type: energyQuantityType,
                                                 quantity: calorieQuantity,
                                                 start: interval.start,
                                                 end: interval.end)
           }

           return samples
       }
}
