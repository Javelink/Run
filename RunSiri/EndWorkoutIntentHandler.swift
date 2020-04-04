//
//  EndWorkoutIntentHandler.swift
//  AssistMeIntent
//
//  Created by Radyslav Krechet on 3/31/19.
//  Copyright © 2019 RubyGarage. All rights reserved.
//

import Intents
import RunSiriCore

class EndWorkoutIntentHandler: NSObject, INEndWorkoutIntentHandling {

    // MARK: - INEndWorkoutIntentHandling
    func handle(intent: INEndWorkoutIntent, completion: @escaping (INEndWorkoutIntentResponse) -> Void) {
        var result: INEndWorkoutIntentResponse!

        guard let workoutName = intent.workoutName else { return }

        TrainingSession.shared.end()
        TrainingSession.shared.save(workoutName)
        result = INEndWorkoutIntentResponse(code: .success, userActivity: nil)
        completion(result)
    }
}
