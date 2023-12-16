//
//  HomepageViewModel.swift
//  NewsNuggets
//
//  Created by Mostafa Alaa on 16/12/2023.
//

import Combine
import SwiftUI
import CoreLocation
import SwiftData


protocol HomepageViewModelProtocol: WeatherViewModelProtocol, ArticleViewModelProtocol, UserPreferencesViewModelProtocol, ObservableObject {

}
class HomepageViewModel: NSObject, ObservableObject, Identifiable, HomepageViewModelProtocol {
    private let newsFetcher: any Collection<any NewsFetchable>
    private let weatherFetcher: WeatherFetchable
    private var modelContext: ModelContext
    private let locationManager = CLLocationManager()
    private var disposables = Set<AnyCancellable>()

    var storedCategories: [CategoriesModel] = [CategoriesModel(name: "technology"), CategoriesModel(name: "business"), CategoriesModel(name: "entertainment"), CategoriesModel(name: "general"), CategoriesModel(name: "health"), CategoriesModel(name: "science"), CategoriesModel(name: "sports"), CategoriesModel(name: "technology")]

    @Published var state: String?
    @Published var temp: String?
    @Published var iconURL: String?
    @Published var countryCode: String?
    @Published var headlinesDataSource: [Article] = []
    var userCategories: [CategoriesModel] = []

    var timeOfDay: String?
    var calendarDate: String?
    private var apiInProgress=false

    init(newsFetcher: some Collection<any NewsFetchable>, weatherFetcher: WeatherFetchable, modelContext: ModelContext) {
        self.newsFetcher = newsFetcher
        self.weatherFetcher = weatherFetcher
        self.modelContext = modelContext
        super.init()
        bindCountryCodeToNewsCall()
        locationManager.delegate = self
        self.requestLocationData()
        fetchDateData()
        getUserCategories()
    }
    func bindCountryCodeToNewsCall() {
        $countryCode
            .sink { code in
                for i in self.newsFetcher {
                    self.getHeadlines(newsFetcher: i, countryCode: code)
                }
            }
            .store(in: &disposables)
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
    func getHeadlines(newsFetcher: some NewsFetchable, countryCode: String?) {
        if countryCode != nil {
            newsFetcher.fetchHeadlines(countryCode: countryCode!)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self.headlinesDataSource = []
                        print("error is \(error.errorDescription ?? "")")
                    }
                } receiveValue: { newsModel in
                    if newsModel.articles != nil {
                        self.headlinesDataSource.append(contentsOf: newsModel.articles!.compactMap { Article(articleGenericMode: $0)})
                        self.headlinesDataSource.shuffle()
                    }
                }
                .store(in: &disposables)
        }
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
    private func getCountryCode(location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Reverse geocoding failed with error: \(error.localizedDescription)")
                return
            }

            if let country = placemarks?.first?.isoCountryCode {
                self.countryCode = country
            } else {
                print("Could not determine country code")
            }
        }
    }
    func getUserCategories() {
        do {
            let descriptor = FetchDescriptor<CategoriesModel>(sortBy: [SortDescriptor(\.name)])
            userCategories = try modelContext.fetch(descriptor)
        } catch {
            print("Fetch failed")
        }
    }
    func addCategory(category: CategoriesModel) {
        modelContext.insert(category)
    }
    func deleteCategory(category: CategoriesModel) {
        modelContext.delete(category)
    }
}
extension HomepageViewModel : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error){
        print("error is \(error.localizedDescription)")

    }

    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            locationManager.stopUpdatingLocation()
            if apiInProgress == false {
                self.fetchWeather(forLat: String(lastLocation.coordinate.latitude), andLong: String(lastLocation.coordinate.longitude))
                self.getCountryCode(location: lastLocation)
                self.apiInProgress = true
            }
        }
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = self.locationManager.authorizationStatus
        switch status {
        case .authorizedWhenInUse, .authorizedAlways, .notDetermined:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            break
        default:
            print("Wrong authorization status \(status)")
        }
    }
}
class MockHomePageViewModel: HomepageViewModelProtocol {

    var headlinesDataSource: [Article] = [
        Article(id: "123", title: "Dummy Article one", source: "CNN"),
        Article(id: "456", title: "Dummy Article two", source: "BBC"),
        Article(id: "789", title: "Dummy Article three", source: "FOX"),
        Article(id: "135", title: "Dummy Article four", source: "ALJAZIRRA"),
        Article(id: "246", title: "Dummy Article five", source: "BEIN"),
        Article(id: "235", title: "Dummy Article six", source: "ON"),
    ]

    var state: String? = "Cool"
    var temp: String? = "32"
    var countryCode: String? = "EG"
    var iconURL: String? = "https://openweathermap.org/img/wn/10d@2x.png"
    var timeOfDay: String? = "Good morning"
    var calendarDate: String? = "12/Dec/2023"

    var userCategories: [CategoriesModel] = []

}
