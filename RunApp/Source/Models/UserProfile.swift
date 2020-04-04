//
//  Models.swift
//  RunApp
//
//  Created by Javelink on 12/25/19.
//  Copyright © 2019 Andrey Slota. All rights reserved.
//

import Foundation
import HealthKit

final class UserProfile {
    var age: Int?
    var biologicalSex: HKBiologicalSex?
    var bloodType: HKBloodType?
    var heightInMeters: Double?
    var weightInKilograms: Double?
  
    var bodyMassIndex: Double? {
        guard let weightInKilograms = weightInKilograms,
              let heightInMeters = heightInMeters,
              heightInMeters > 0 else {
            return nil
        }
    
        return (weightInKilograms / (heightInMeters * heightInMeters))
    }
}
