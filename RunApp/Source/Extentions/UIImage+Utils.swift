//
//  UIImage+Utils.swift
//  RunApp
//
//  Created by Andrey Slota on 1/15/20.
//  Copyright © 2020 Andrey Slota. All rights reserved.
//

import UIKit

enum ImagesSystem: String {
    case person = "person.circle"
    case list   = "list.bullet"
    case hare   = "hare"
}

extension UIImage {

    class func imageForTabBar(_ name: ImagesSystem) -> UIImage {
        return imageWithSFSymbols(name, pointSize: 22.5)
    }

    class func imageWithSFSymbols(_ name: ImagesSystem, pointSize: CGFloat) -> UIImage {
        return UIImage(systemName: name.rawValue, withConfiguration: UIImage.SymbolConfiguration(pointSize: pointSize, weight: .bold))!
    }
}
