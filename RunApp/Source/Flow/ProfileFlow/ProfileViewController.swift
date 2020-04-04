//
//  ProfileViewController.swift
//  RunApp
//
//  Created by Andrey Slota on 12/19/19.
//  Copyright © 2019 Andrey Slota. All rights reserved.
//

import UIKit

final class ProfileViewController: UITableViewController {

    // MARK: - Properties
    @IBOutlet private weak var ageLabel: UILabel!
    @IBOutlet private weak var sexLabel: UILabel!
    @IBOutlet private weak var bloodLabel: UILabel!
    @IBOutlet private weak var weightLabel: UILabel!
    @IBOutlet private weak var heightLabel: UILabel!
    @IBOutlet private weak var bmiLabel: UILabel!
    
    private var assistant = HealthAssistant()

    // MARK: - Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        assistant.delegate = self
        assistant.updateHealthInfo()
        navigationController?.setupNavigationStyle()
        tableView.tableFooterView = UIView(frame: .zero)
    }
}

// MARK: - HealthUpdateble
extension ProfileViewController: HealthUpdateble {
    func updateInfoLabels() {
        let userHealthProfile = assistant.userProfile

        guard let age = userHealthProfile.age,
              let sex = userHealthProfile.biologicalSex,
              let blood = userHealthProfile.bloodType else {
            return
        }

        ageLabel.text = "\(age)"
        sexLabel.text = sex.stringRepresentation
        bloodLabel.text = blood.stringRepresentation
    }

    func updateParametersLabels() {
        let userHealthProfile = assistant.userProfile

        guard let weight = userHealthProfile.weightInKilograms,
              let height = userHealthProfile.heightInMeters else {
            return
        }

        let weightFormatter = MassFormatter()
        weightFormatter.isForPersonMassUse = true
        weightLabel.text = weightFormatter.string(fromValue: weight, unit: .kilogram)

        let heightFormatter = LengthFormatter()
        heightFormatter.isForPersonHeightUse = true
        heightLabel.text = heightFormatter.string(fromValue: height, unit: .meter)
    }
}
