//
//  Training.swift
//  RunApp
//
//  Created by Andrey Slota on 1/2/20.
//  Copyright © 2020 Andrey Slota. All rights reserved.
//

import Foundation
import Intents

public struct Training {

    public enum TrainingKind: String, CaseIterable {
        case running
        case walking

        public init?(intentWorkoutName: INSpeakableString) {
            switch intentWorkoutName.spokenPhrase.lowercased() {
            case "walk":
                self = .walking
            case "run":
                self = .running
            default:
                return nil
            }
        }

        public var speakableString: INSpeakableString {
            let identifier: String
            let phrase: String
            let hint: String

            switch self {
            case .walking:
                identifier = "id-workouttype-walk"
                phrase = "Walk"
                hint = "walk"
            case .running:
                identifier = "id-workouttype-run"
                phrase = "Run"
                hint = "run"
            }

            if #available(iOS 11.0, *) {
                return INSpeakableString(vocabularyIdentifier: identifier, spokenPhrase: phrase, pronunciationHint: hint)
            } else {
                return INSpeakableString(identifier: identifier, spokenPhrase: phrase, pronunciationHint: hint)
            }
        }
    }

    public enum TrainingSessionState: String, CaseIterable {
        case notStarted
        case active
        case finished
    }
    
    public var start: Date
    public var end: Date
    public var intervals: [TrainingInterval]

    public init(_ intervals: [TrainingInterval]) {
        self.start = intervals.first!.start
        self.end = intervals.last!.end
        self.intervals = intervals
    }

    public var totalEnergyBurned: Double {
        return intervals.reduce(0) { (result, interval) in
            result + interval.totalEnergyBurned
        }
    }

    public var duration: TimeInterval {
        return intervals.reduce(0) { (result, interval) in
            result + interval.duration
        }
    }
}
