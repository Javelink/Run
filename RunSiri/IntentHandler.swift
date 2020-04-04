//
//  IntentHandler.swift
//  RunSiri
//
//  Created by Andrey Slota on 1/9/20.
//  Copyright © 2020 Andrey Slota. All rights reserved.
//

import Intents

class IntentHandler: INExtension {
    override func handler(for intent: INIntent) -> Any? {
        if intent is INStartWorkoutIntent {
            return StartWorkoutIntentHandler()
        } else if intent is INEndWorkoutIntent {
            return EndWorkoutIntentHandler()
        }
        return nil
    }
}
