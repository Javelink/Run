//
//  LocationManager.swift
//  RunApp
//
//  Created by Andrey Slota on 12/19/19.
//  Copyright © 2019 Andrey Slota. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

protocol DistanceUpdatable: class {
    func updateDistance(_ distance: String)
}

protocol DistanceWatchUpdatable: class {
    func updateDistance(_ distance: String)
}

final class LocationManager: NSObject {

    static let shared = LocationManager()

    override init() {}

    private var startLocation: CLLocation?
    private var lastLocation: CLLocation?
    private var distanceTraveled = 0.0
    private let locationManager = CLLocationManager()

    weak var distanceDelegate: DistanceUpdatable?
    weak var watchUpdate: DistanceWatchUpdatable?

    var region = MKCoordinateRegion()

    func startTreckLocation() {
        locationManager.requestWhenInUseAuthorization()

        switch CLLocationManager.locationServicesEnabled() {
        case true:
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        default:
            print("Need to Enable Location")
        }
    }

    func startUpdateLocation() {
        distanceTraveled = 0.0
        startLocation = nil
        lastLocation = nil
        locationManager.startUpdatingLocation()
    }

    func stopUpdateLocation() {
        locationManager.stopUpdatingLocation()
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        switch startLocation {
        case nil:
            startLocation = locations.first
        default:
            guard let locationsLast = locations.last,
                  let lastDistance = lastLocation?.distance(from: locationsLast) else {
                return
            }

            distanceTraveled += lastDistance * 0.000621371
            let trimmedDistance = String(format: "%.2f", distanceTraveled)
            distanceDelegate?.updateDistance("\(trimmedDistance), m")
            watchUpdate?.updateDistance("\(trimmedDistance), m")
        }

        lastLocation = locations.last
    }
}

// MARK: - Setup
extension LocationManager {
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.allowsBackgroundLocationUpdates = true
    }
}
