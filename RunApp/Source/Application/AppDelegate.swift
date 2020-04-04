//
//  AppDelegate.swift
//  RunApp
//
//  Created by Andrey Slota on 12/19/19.
//  Copyright © 2019 Andrey Slota. All rights reserved.
//

import UIKit
import CoreData
import Intents
import RunSiriCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var response: INIntentResponse!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        requestSiriAuthorization()
        return true
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, handle intent: INIntent, completionHandler: @escaping (INIntentResponse) -> Void) {


        if let startIntent = intent as? INStartWorkoutIntent {
            startIntents(startIntent)
            response = INStartWorkoutIntentResponse(code: .success, userActivity: nil)
        } else if let _ = intent as? INEndWorkoutIntent {
            TrainingSession.shared.end()
            response = INEndWorkoutIntentResponse(code: .success, userActivity: nil)
        } else {
            response = INStartWorkoutIntentResponse(code: .failure, userActivity: nil)
        }

        completionHandler(response)
    }

    private func startIntents(_ intent: INStartWorkoutIntent) {
        switch Training.TrainingKind(intentWorkoutName: intent.workoutName!) {
        case .running:
            TrainingSession.shared.start(.running)
        case .walking:
            TrainingSession.shared.start(.walking)
        default:
            break
        }
    }

    // MARK: - Setup
    private func requestSiriAuthorization() {
        INPreferences.requestSiriAuthorization { status in }
    }

    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "RunApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
