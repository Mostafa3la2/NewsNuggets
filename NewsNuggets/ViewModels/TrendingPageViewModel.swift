//
//  TrendingPageViewModel.swift
//  NewsNuggets
//
//  Created by Mostafa Alaa on 26/12/2023.
//

import Foundation
import Combine

struct CategoryDataSource: Hashable {
    var name: String?
    var selected: Bool = false
}
class TrendingPageViewModel: NSObject, ObservableObject, Identifiable {

    private let newsFetcher: any Collection<any NewsFetchable>
    private var disposables = Set<AnyCancellable>()
    private let categoriesManager: CategoriesManager

    @Published var categoriesDataSource: [CategoryDataSource]
    @Published var tailoredNewsDataSource: [Article] = []
    var countryCode: String?
    var selectedCategoryIndex = 0
    init(newsFetcher: some Collection<any NewsFetchable>, categoriesManager: CategoriesManager) {
        self.newsFetcher = newsFetcher
        self.categoriesManager = categoriesManager
        self.categoriesDataSource = categoriesManager.getAllCategories()?.map{CategoryDataSource(name: $0.name)} ?? []
        self.countryCode = UserDefaults.standard.string(forKey: "country")
        super.init()
        self.categoriesDataSource[0].selected = true
        getNewsForSavedCategories()
    }
    func selectCategory(categoryIndex: Int) {
        selectedCategoryIndex = categoryIndex
        for i in 0..<categoriesDataSource.count-1 {
            if i != categoryIndex {
                categoriesDataSource[i].selected = false
            } else {
                categoriesDataSource[i].selected = true
            }
        }
        getNewsForSavedCategories()
    }

    func getNewsForSavedCategories() {
        for newsFetcher in self.newsFetcher {
            self.getNewsForSavedCategory(newsFetcher: newsFetcher)
        }
    }
    private func getNewsForSavedCategory(newsFetcher: some NewsFetchable) {
        newsFetcher.fetchNewsInCategory(countryCode: countryCode?.lowercased() ?? "", category: categoriesDataSource[selectedCategoryIndex].name ?? "")
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
    func getRemainingArticles() -> [Article] {
        let remainingArticles = tailoredNewsDataSource.filter{$0.id != tailoredNewsDataSource.first?.id}
        print("remaining articles are \(remainingArticles)")
        return remainingArticles
    }
}
