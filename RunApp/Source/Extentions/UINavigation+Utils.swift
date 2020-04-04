//
//  UINavigation+Utils.swift
//  RunApp
//
//  Created by Javelink on 12/26/19.
//  Copyright © 2019 Andrey Slota. All rights reserved.
//

import UIKit

extension UINavigationController {
    func setupNavigationStyle() {
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor.purple,
                                             .font: UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .headline),
                                                           size: 30)]
    }
    
    func hiddenBar() {
        navigationBar.isHidden = false
    }
}
