//
//  HKBiologicalSex+StringRepresentation.swift
//  RunApp
//
//  Created by Javelink on 12/25/19.
//  Copyright © 2019 Andrey Slota. All rights reserved.
//

import Foundation
import HealthKit

extension HKBiologicalSex {
  
    var stringRepresentation: String {
        switch self {
        case .notSet: return "Unknown"
        case .female: return "Female"
        case .male: return "Male"
        case .other: return "Other"
        default: return ""
        }
    }
}
