//
//  InterfaceController.swift
//  RunWatch Extension
//
//  Created by Andrey Slota on 1/16/20.
//  Copyright © 2020 Andrey Slota. All rights reserved.
//

import WatchKit
import Foundation

final class InterfaceController: WKInterfaceController {

    @IBOutlet private weak var mapView: WKInterfaceMap!

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }

    @IBAction private func onRuun() {
        DispatchQueue.main.async { [weak self] in
            self?.pushController(withName: "TimerRunWatchController", context: 0)
        }
    }

    @IBAction private func onWalk() {
        DispatchQueue.main.async { [weak self] in
            self?.pushController(withName: "TimerRunWatchController", context: 1)
        }
    }
}
