//
//  WeatherViewModel.swift
//  NewsNuggets
//
//  Created by Mostafa Alaa on 24/11/2023.
//

import Combine
import SwiftUI
import CoreLocation


class WeatherViewModel: NSObject, ObservableObject, Identifiable {
    private let weatherFetcher: WeatherFetchable

    @Published var state: String?
    @Published var temp: String?
    @Published var iconURL: String?
    var timeOfDay: String?
    var calendarDate: String?
    private var iconBaseURL = "https://openweathermap.org/img/wn/{0}@2x.png"
    private var disposables = Set<AnyCancellable>()
    private let locationManager = CLLocationManager()

    func fetchWeather(forLat: String, andLong: String) {
        weatherFetcher.fetchWeather(forLat: forLat, andLong: andLong)
            .receive(on: DispatchQueue.main)
            .sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                print("error is \(error.errorDescription ?? "")")
            }
        } receiveValue: { weatherModel in
            self.temp = String(weatherModel.main?.temp ?? 0)
            self.state = String(weatherModel.weather?.first?.main ?? "")
            self.iconURL = self.iconBaseURL.replacingOccurrences(of: "{0}", with: weatherModel.weather?.first?.icon ?? "")
        }
        .store(in: &disposables)
    }
    func fetchDateData() {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        if (5..<12).contains(hour) {
            timeOfDay = "Good morning"
        } else if (12..<18).contains(hour) {
            timeOfDay = "Good afternoon"

        } else if hour < 24 {
            timeOfDay = "Good evening"

        } else {
            timeOfDay = "Goodnight"
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        calendarDate = dateFormatter.string(from: date)
    }

    init(weatherFetcher: WeatherFetchable) {
        self.weatherFetcher = weatherFetcher
        super.init()
        locationManager.delegate = self
        self.requestLocationData()
        fetchDateData()

    }
    public func canAccessLocation() -> Bool {
        let access = self.locationManager.authorizationStatus
        print("access is \(access)")
        return access == .authorizedAlways || access == .authorizedWhenInUse
    }
    func requestLocationData() {
        if(self.locationManager.authorizationStatus == .notDetermined) {
            self.locationManager.requestWhenInUseAuthorization()
        }
        if(canAccessLocation()){
            self.locationManager.requestLocation()
        }
    }

}
extension WeatherViewModel : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error){
        print("error is \(error.localizedDescription)")

    }

    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            locationManager.stopUpdatingLocation()
            self.fetchWeather(forLat: String(lastLocation.coordinate.latitude), andLong: String(lastLocation.coordinate.longitude))
        }
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        locationManager.startUpdatingLocation()
    }
}
