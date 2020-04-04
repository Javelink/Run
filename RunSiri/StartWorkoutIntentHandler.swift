//
//  StartWorkoutIntentHandler.swift
//  AssistMeIntent
//
//  Created by Radyslav Krechet on 3/31/19.
//  Copyright © 2019 RubyGarage. All rights reserved.
//

import Intents
import RunSiriCore

final class StartWorkoutIntentHandler: NSObject, INStartWorkoutIntentHandling {

    // MARK: - INStartWorkoutIntentHandling
    func resolveWorkoutName(for intent: INStartWorkoutIntent,
                            with completion: @escaping (INSpeakableStringResolutionResult) -> Void) {

        var result: INSpeakableStringResolutionResult!

        if let workoutName = intent.workoutName {
            TrainingSession.shared.startWorkout(workoutName)
            result = INSpeakableStringResolutionResult.success(with: workoutName)
        } else {
            result = INSpeakableStringResolutionResult.needsValue()
        }

        completion(result)
    }

    func resolveIsOpenEnded(for intent: INStartWorkoutIntent, with completion: @escaping (INBooleanResolutionResult) -> Void) {
        let result: INBooleanResolutionResult

        if let openEnded = intent.isOpenEnded {
            result = INBooleanResolutionResult.success(with: openEnded)
        } else {
            result = INBooleanResolutionResult.notRequired()
        }

        completion(result)
    }

    func handle(intent: INStartWorkoutIntent, completion: @escaping (INStartWorkoutIntentResponse) -> Void) {
        let result: INStartWorkoutIntentResponse

        switch Training.TrainingSessionState(rawValue: "") {
        case .finished:
            result = INStartWorkoutIntentResponse(code: .handleInApp, userActivity: nil)
        default:
            result = INStartWorkoutIntentResponse(code: .success, userActivity: nil)
        }

        completion(result)
    }
}
