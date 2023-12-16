//
//  LocationServicesManager.swift
//  NewsNuggets
//
//  Created by Mostafa Alaa on 16/12/2023.
//

import Foundation
import CoreLocation
import SwiftUI

extension Notification.Name {
    static let locationUpdated          = Notification.Name("LocationUpdated")
    static let locationAlertDismissed    = Notification.Name("LocationAlertDismissed")
}

final class LocationServicesManager: NSObject {

    static let shared = LocationServicesManager()
    private let locationManager: CLLocationManager
    var status: CLAuthorizationStatus

    override init() {
        locationManager = CLLocationManager()
        status = locationManager.authorizationStatus
        super.init()
        locationManager.delegate = self
    }
    var isAuthorized: Bool {
        return status == .authorizedWhenInUse || status == .authorizedAlways || status == .notDetermined
    }

    var isAuthorizationRequested: Bool {
        return status != .notDetermined
    }

    var isLocationServiceEnabled: Bool {
        return CLLocationManager.locationServicesEnabled()
    }
    func startListening() {
        locationManager.startUpdatingLocation()
    }

    func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }

    func stopListening() {
        locationManager.stopUpdatingLocation()
    }
}
extension LocationServicesManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error){
        print("error is \(error.localizedDescription)")

    }

    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        if locations.last != nil {
            manager.stopUpdatingLocation()
            NotificationCenter.default.post(name: .locationUpdated, object: nil, userInfo: ["locations": locations])

        }
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        switch status {
        case .authorizedWhenInUse, .authorizedAlways, .notDetermined:
            self.status = status
            manager.startUpdatingLocation()
        case .denied, .restricted:
            self.status = status
            NotificationCenter.default.post(name: .locationAlertDismissed, object: nil, userInfo: nil)
        default:
            print("Wrong authorization status \(status)")
        }
    }
}
