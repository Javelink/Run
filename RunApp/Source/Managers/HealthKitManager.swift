//
//  HealthKitManager.swift
//  RunApp
//
//  Created by Andrey Slota on 12/19/19.
//  Copyright © 2019 Andrey Slota. All rights reserved.
//

import Foundation
import HealthKit

final class HealthKitManager {
    let healthStore: HKHealthStore = HKHealthStore()

    func authorizeHealthKit(completion: @escaping((Bool, Error?) -> Void)) {
        if HKHealthStore.isHealthDataAvailable() {
            let infoToRead = Set([HKSampleType.characteristicType(forIdentifier: .biologicalSex)!,
                                  HKSampleType.characteristicType(forIdentifier: .dateOfBirth)!,
                                  HKSampleType.characteristicType(forIdentifier: .bloodType)!,
                                  HKSampleType.quantityType(forIdentifier: .activeEnergyBurned)!,
                                  HKSampleType.quantityType(forIdentifier: .distanceWalkingRunning)!,
                                  HKSampleType.quantityType(forIdentifier: .bodyMass)!,
                                  HKSampleType.quantityType(forIdentifier: .height)!,
                                  HKSampleType.quantityType(forIdentifier: .headphoneAudioExposure)!,
                                  HKSampleType.workoutType()])

            let infoToWrite = Set([HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
                                   HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
                                   HKObjectType.workoutType()])

            healthStore.requestAuthorization(toShare: infoToWrite, read: infoToRead, completion: { (success, error) in

                guard error != nil else {
                    print(error as Any)
                    return
                }

                completion(success, error)
            })
        } else {
            print("ERROR authorizeHealthKit")
        }
    }
}
