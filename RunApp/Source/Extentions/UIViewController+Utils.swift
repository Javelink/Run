//
//  UIViewController+Utils.swift
//  FilmsTMDb
//
//  Created by Andrey Slota on 11/18/19.
//  Copyright © 2019 Andrey Slota. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    class func loadFromStoryboard(_ name: Storyboards) -> Self {
        return instantiateFromStoryboardHelper(name)
    }

    private class func instantiateFromStoryboardHelper<T>(_ name: Storyboards) -> T {
        let storyboard = UIStoryboard(name: name.rawValue, bundle: nil)

        guard let controller = storyboard.instantiateViewController(withIdentifier: String(describing: self)) as? T else {
            fatalError("fatalError")
        }

        return controller
    }
}
