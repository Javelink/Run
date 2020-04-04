//
//  HealthAssistant.swift
//  RunApp
//
//  Created by Andrey Slota on 1/2/20.
//  Copyright © 2020 Andrey Slota. All rights reserved.
//

import Foundation
import HealthKit

protocol HealthUpdateble: class {
    func updateInfoLabels()
    func updateParametersLabels()
}

final class HealthAssistant: NSObject {

    weak var delegate: HealthUpdateble?
    let userProfile = UserProfile()
    let profileData = ProfileDataStore()

    func updateHealthInfo() {
        loadAgeSexAndBloodType()
        loadMostRecentWeight()
        loadMostRecentHeight()
    }
}

// MARK: - Load User Data
private extension HealthAssistant {

    private func loadAgeSexAndBloodType() {

        do {
            let userAgeSexAndBloodType = try profileData.getAgeSexAndBloodType()
            userProfile.age = userAgeSexAndBloodType.age
            userProfile.biologicalSex = userAgeSexAndBloodType.biologicalSex
            userProfile.bloodType = userAgeSexAndBloodType.bloodType
            delegate?.updateInfoLabels()
        } catch let error {
            print(error)
        }
    }

    private func loadMostRecentHeight() {

        guard let heightSampleType = HKSampleType.quantityType(forIdentifier: .height) else {
            print("Height Sample Type is no longer available in HealthKit")
            return
        }

        profileData.getMostRecentSample(for: heightSampleType) { [weak self] (sample, error) in

            guard let sample = sample, error == nil else {
                print(error as Any)
                return
            }

            let heightInMeters = sample.quantity.doubleValue(for: HKUnit.meter())
            self?.userProfile.heightInMeters = heightInMeters
            self?.delegate?.updateParametersLabels()
        }
    }

    private func loadMostRecentWeight() {

        guard let weightSampleType = HKSampleType.quantityType(forIdentifier: .bodyMass) else {
            print("Body Mass Sample Type is no longer available in HealthKit")
            return
        }

        profileData.getMostRecentSample(for: weightSampleType) { [weak self] (sample, error) in

            guard let sample = sample, error == nil else {
                print(error as Any)
                return
            }

            let weightInKilograms = sample.quantity.doubleValue(for: HKUnit.gramUnit(with: .kilo))
            self?.userProfile.weightInKilograms = weightInKilograms
            self?.delegate?.updateParametersLabels()
        }
    }
}
