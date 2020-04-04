//
//  HKBloodType+StringRepresentation.swift
//  RunApp
//
//  Created by Andrey Slota on 1/2/20.
//  Copyright © 2020 Andrey Slota. All rights reserved.
//

import HealthKit

extension HKBloodType {

    var stringRepresentation: String {
        switch self {
        case .notSet: return "Unknown"
        case .aPositive: return "A+"
        case .aNegative: return "A-"
        case .bPositive: return "B+"
        case .bNegative: return "B-"
        case .abPositive: return "AB+"
        case .abNegative: return "AB-"
        case .oPositive: return "O+"
        case .oNegative: return "O-"
        default: return ""
        }
    }
}
