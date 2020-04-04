//
//  TrainingInterval.swift
//  RunApp
//
//  Created by Andrey Slota on 1/2/20.
//  Copyright © 2020 Andrey Slota. All rights reserved.
//

import Foundation

public struct TrainingInterval {
    public var start: Date
    public var end: Date

    public init(start: Date, end: Date) {
        self.start = start
        self.end = end
    }

    public var duration: TimeInterval {
        return end.timeIntervalSince(start)
    }

    public var totalEnergyBurned: Double {
        let prancerciseCaloriesPerHour: Double = 450
        let hours: Double = duration/3600
        let totalCalories = prancerciseCaloriesPerHour * hours
        return totalCalories
    }
}
