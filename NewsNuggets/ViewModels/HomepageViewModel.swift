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


protocol HomepageViewModelProtocol: ArticleViewModelProtocol, UserPreferencesViewModelProtocol, ObservableObject {

}
class HomepageViewModel: NSObject, ObservableObject, Identifiable, HomepageViewModelProtocol {
    private let newsFetcher: any Collection<any NewsFetchable>
    private let categoriesManager: CategoriesManager
    private let locationManager = CLLocationManager()
    private var disposables = Set<AnyCancellable>()

    var storedCategories: [CategoriesModel] = [CategoriesModel(name: "technology"), CategoriesModel(name: "business"), CategoriesModel(name: "entertainment"), CategoriesModel(name: "general"), CategoriesModel(name: "health"), CategoriesModel(name: "science"), CategoriesModel(name: "sports")]

    @Published var state: String?
    @Published var temp: String?
    @Published var iconURL: String?
    @Published var countryCode: String?
    @Published var headlinesDataSource: [Article] = []
    @Published var tailoredNewsDataSource: [Article] = []

    var userCategories: [CategoriesModel] = []

    var timeOfDay: String?
    var calendarDate: String?
    private var apiInProgress=false

    init(newsFetcher: some Collection<any NewsFetchable>, categoriesManager: CategoriesManager) {
        self.newsFetcher = newsFetcher
        self.categoriesManager = categoriesManager
        super.init()
        userCategories = categoriesManager.fetchCategories() ?? []
        bindCountryCodeToNewsCall()
        checkLocationToGetCoordinates()
    }
    func bindCountryCodeToNewsCall() {
        $countryCode
            .dropFirst()
            .sink { code in
                if code != nil {
                    for i in self.newsFetcher {
                        self.getHeadlines(newsFetcher: i, countryCode: code)
                    }
                    if !self.userCategories.isEmpty {
                        self.getNewsForSavedCategories(countryCode: code!)
                    }
                }
            }
            .store(in: &disposables)
    }
    func getHeadlines(newsFetcher: some NewsFetchable, countryCode: String?) {
        newsFetcher.fetchHeadlines(countryCode: countryCode!.lowercased())
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
    func getNewsForSavedCategories(countryCode: String) {
        for newsFetcher in self.newsFetcher {
            self.getNewsForSavedCategory(newsFetcher: newsFetcher, countryCode: countryCode)
        }
    }
    private func getNewsForSavedCategory(newsFetcher: some NewsFetchable, countryCode: String) {

        for category in userCategories {
            newsFetcher.fetchNewsInCategory(countryCode: countryCode.lowercased(), category: category.name)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print("error is \(error.errorDescription ?? "")")
                    }
                } receiveValue: { newsModel in
                    if newsModel.articles != nil {
                        self.tailoredNewsDataSource.append(contentsOf: newsModel.articles!.compactMap { Article(articleGenericMode: $0)})
                        self.tailoredNewsDataSource.shuffle()
                    }
                }
                .store(in: &disposables)
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
    func addCategory(category: CategoriesModel) {
        userCategories = self.categoriesManager.addCategoryAndRefresh(category: category) ?? []
    }
    func deleteCategory(category: CategoriesModel) {
        userCategories = self.categoriesManager.deleteCategoryAndRefresh(category: category) ?? []
    }
}
extension HomepageViewModel {
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
                    self.getCountryCode(location: location)
                }
            }
            NotificationCenter.default.removeObserver(self)
        }
    }
}
class MockHomePageViewModel: HomepageViewModelProtocol {
    var tailoredNewsDataSource: [Article] = [
        Article(id: "123", title: "Dummy Article one", source: "CNN"),
        Article(id: "456", title: "Dummy Article two", source: "BBC"),
        Article(id: "789", title: "Dummy Article three", source: "FOX"),
        Article(id: "135", title: "Dummy Article four", source: "ALJAZIRRA"),
        Article(id: "246", title: "Dummy Article five", source: "BEIN"),
        Article(id: "235", title: "Dummy Article six", source: "ON"),
    ]


    var headlinesDataSource: [Article] = [
        Article(id: "123", title: "Dummy Article one", source: "CNN"),
        Article(id: "456", title: "Dummy Article two", source: "BBC"),
        Article(id: "789", title: "Dummy Article three", source: "FOX"),
        Article(id: "135", title: "Dummy Article four", source: "ALJAZIRRA"),
        Article(id: "246", title: "Dummy Article five", source: "BEIN"),
        Article(id: "235", title: "Dummy Article six", source: "ON"),
    ]

    var userCategories: [CategoriesModel] = []
    var storedCategories: [CategoriesModel] = [CategoriesModel(name: "technology"), CategoriesModel(name: "business"), CategoriesModel(name: "entertainment"), CategoriesModel(name: "general"), CategoriesModel(name: "health"), CategoriesModel(name: "science"), CategoriesModel(name: "sports")]

}
