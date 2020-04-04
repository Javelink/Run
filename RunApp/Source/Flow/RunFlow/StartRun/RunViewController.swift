//
//  ViewController.swift
//  RunApp
//
//  Created by Andrey Slota on 12/19/19.
//  Copyright © 2019 Andrey Slota. All rights reserved.
//

import UIKit
import MapKit
import RunSiriCore

final class RunViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var startButton: UIButton!
    @IBOutlet private weak var chooseWorkout: UISegmentedControl!

    // MARK: - Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hiddenBar()
        tabBarController?.tabBar.isHidden = false
    }

    // MARK: - Private Func
    private func setupMapView() {
        mapView?.delegate = self
        mapView?.showsUserLocation = true
        mapView.tintColor = .purple
    }

    private func setup() {
        setupMapView()
        LocationManager.shared.setupLocationManager()
        navigationController?.setupNavigationStyle()
        tabBarController?.tabBar.tintColor = .purple
    }

    // MARK: - Action
    @IBAction private func onStart(_ sender: UIButton) {
        let controller = TimerRunViewController.loadFromStoryboard(.runTimer)
        controller.index = chooseWorkout.selectedSegmentIndex
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - MKMapViewDelegate
extension RunViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {

        guard let userLocation = userLocation.location?.coordinate else { return }

        let center = CLLocationCoordinate2D(latitude: userLocation.latitude,
                                            longitude: userLocation.longitude)
        LocationManager.shared.region = MKCoordinateRegion(center: center,
                                                    span: MKCoordinateSpan(latitudeDelta: 0.01,
                                                                           longitudeDelta: 0.01))
        mapView.setRegion(LocationManager.shared.region, animated: true)
    }
}
