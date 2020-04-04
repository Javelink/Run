//
//  TabBarController.swift
//  RunApp
//
//  Created by Andrey Slota on 12/19/19.
//  Copyright © 2019 Andrey Slota. All rights reserved.
//

import UIKit

final class TabBarController: UITabBarController {

    private let healthManager = HealthKitManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = navControllers()
        getHealthKitPermission()
        imagesTabBar()
    }
}

// MARK: - Items For TabBar
private extension TabBarController {

    private func viewControllers() -> [UIViewController] {
        let runVC = RunViewController.loadFromStoryboard(.main)
        let profileVC = ProfileViewController.loadFromStoryboard(.profile)
        let historyVC = HistoryViewController.loadFromStoryboard(.history)
        let arrayOfVC: [UIViewController] = [runVC, profileVC, historyVC]
        return arrayOfVC
    }

    private func navControllers() -> [UINavigationController] {
        var arrayNavVC: [UINavigationController] = []

        for viewC in viewControllers() {
            let navigationBar = UINavigationController(rootViewController: viewC)
            arrayNavVC.append(navigationBar)
        }

        return arrayNavVC
    }

    private func imagesTabBar() {
        let person: UIImage = .imageForTabBar(.person)
        let list: UIImage = .imageForTabBar(.list)
        let hare: UIImage = .imageForTabBar(.hare)

        let titleImages = [hare, person, list]

        guard let items = self.tabBar.items else { return }

        for index in 0..<items.count {
            items[index].image = titleImages[index]
        }
    }
}

// MARK: - Authorize HealthKit
private extension TabBarController {
    private func getHealthKitPermission() {

        healthManager.authorizeHealthKit { [weak self] (authorized, error) -> Void in

            guard let _ = self else { return }

            switch authorized {
            case true: print("success")
            default: print(error!)
            }
        }
    }
}
