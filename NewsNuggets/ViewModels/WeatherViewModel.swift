//
//  WeatherViewModel.swift
//  NewsNuggets
//
//  Created by Mostafa Alaa on 24/11/2023.
//

import Combine
import SwiftUI
import CoreLocation

protocol WeatherViewModelProtocol: ObservableObject {
    var state: String? { get }
    var temp: String? { get }
    var countryCode: String? { get }
    var iconURL: String? { get }
    var timeOfDay: String? { get }
    var calendarDate: String? { get }
}

class WeatherViewModel: NSObject, WeatherViewModelProtocol, ObservableObject, Identifiable {
    private let weatherFetcher: WeatherFetchable
    private var disposables = Set<AnyCancellable>()

    @Published var state: String?
    @Published var temp: String?
    @Published var iconURL: String?
    @Published var countryCode: String?
    var timeOfDay: String?
    var calendarDate: String?

    private var apiInProgress=false

    init(weatherFetcher: WeatherFetchable) {
        self.weatherFetcher = weatherFetcher
        super.init()
        fetchDateData()
        checkLocationToGetCoordinates()
    }
    func fetchWeather(forLat: String, andLong: String) {
        guard !apiInProgress else {
            return
        }
        weatherFetcher.fetchWeather(forLat: forLat, andLong: andLong)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    self.apiInProgress = false
                    break
                case .failure(let error):
                    self.apiInProgress = false
                    print("error is \(error.errorDescription ?? "")")
                }
            } receiveValue: { weatherModel in
                self.temp = String(floor(weatherModel.main?.temp ?? 0))
                self.state = String(weatherModel.weather?.first?.main ?? "")
                self.iconURL = URLConstants.WEATHER_ICON_BASE_URL.value.replacingOccurrences(of: "{0}", with: weatherModel.weather?.first?.icon ?? "")
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

}
extension WeatherViewModel {
    func checkLocationToGetCoordinates() {
        LocationServicesManager.shared.requestAuthorization()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(locationUpdated(_:)),
                                               name: .locationUpdated,
                                               object: nil)
        LocationServicesManager.shared.startListening()

    }

    @objc private func locationUpdated(_ notification: Notification) {
        if let value = notification.userInfo?["locations"] as? [Any] {
            if value.count > 0 {
                if let location = value.last as? CLLocation {
                    print("location = \(location.coordinate.latitude) , \(location.coordinate.longitude)")
                    self.fetchWeather(forLat: "\(location.coordinate.latitude)", andLong: "\(location.coordinate.longitude)")
                }
            }
            NotificationCenter.default.removeObserver(self)
        }
    }
}
class MockWeatherViewModel: WeatherViewModelProtocol {
    var state: String? = "Cool"
    var temp: String? = "32"
    var countryCode: String? = "EG"
    var iconURL: String? = "https://openweathermap.org/img/wn/10d@2x.png"
    var timeOfDay: String? = "Good morning"
    var calendarDate: String? = "12/Dec/2023"
}
