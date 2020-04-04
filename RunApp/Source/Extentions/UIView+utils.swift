//
//  UIView+utils.swift
//  RunApp
//
//  Created by Andrey Slota on 12/20/19.
//  Copyright © 2019 Andrey Slota. All rights reserved.
//

import UIKit

extension UIView {

    @IBInspectable var cornerRadius: CGFloat {
        set { layer.cornerRadius = newValue  }
        get { return layer.cornerRadius }
    }

    @IBInspectable var borderWidth: CGFloat {
        set { layer.borderWidth = newValue }
        get { return layer.borderWidth }
    }

    @IBInspectable var borderColor: UIColor? {
        set { layer.borderColor = newValue?.cgColor  }
        get { return UIColor(cgColor: layer.shadowColor!) }
    }

    @IBInspectable var shadowOffset: CGSize {
        set { layer.shadowOffset = newValue  }
        get { return layer.shadowOffset }
    }

    @IBInspectable var shadowOpacity: Float {
        set { layer.shadowOpacity = newValue }
        get { return layer.shadowOpacity }
    }

    @IBInspectable var shadowRadius: CGFloat {
        set { layer.shadowRadius = newValue }
        get { return layer.shadowRadius }
    }

    @IBInspectable var shadowColor: UIColor? {
        set { layer.shadowColor = newValue?.cgColor }
        get { return UIColor(cgColor: layer.shadowColor!) }
    }

    @IBInspectable var _clipsToBounds: Bool {
        set { clipsToBounds = newValue }
        get { return clipsToBounds }
    }
}

@IBDesignable extension UINavigationController {
    @IBInspectable var barTintColor: UIColor? {
        set { navigationBar.barTintColor = newValue }
        get {
            guard let color = navigationBar.barTintColor else { return nil }
            return color
        }
    }

    @IBInspectable var tintColor: UIColor? {
        set { navigationBar.tintColor = newValue }
        get {
            guard let color = navigationBar.tintColor else { return nil }
            return color
        }
    }
}
