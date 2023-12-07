//
//  ArticleViewModel.swift
//  NewsNuggets
//
//  Created by Mostafa Alaa on 26/11/2023.
//

import Combine
import SwiftUI

struct ArticlePreviewViewModel: Hashable {

    var id: String?
    var title: String?
    var category: String?
    var imageURL: String?
}

struct ArticleDetailsViewModel {
    var id: String?
    var title: String?
    var body: String?
    var category: String?
    var author: ArticleAuthor?
    var date: String?
    var readTime: String?
}

struct ArticleAuthor {
    var id: String?
    var name: String?
    var imageURL: String?
}


class NewsViewModel: NSObject, ObservableObject, Identifiable {

    @Published var newsModel: NewsModel?
    private let newsFetcher: NewsFetchable
    private var countryCode: String?
    private var disposables = Set<AnyCancellable>()
    @Published var headlinesDataSource: [ArticlePreviewViewModel] = []
    init(newsFetcher: NewsFetchable, locationDataViewModel: LocationRelatedDataViewModel) {
        self.newsFetcher = newsFetcher
        super.init()
        locationDataViewModel.$countryCode
            .sink { [weak self] countryCode in
                self?.countryCode = countryCode?.lowercased()
                self?.getHeadlines()
            }
            .store(in: &disposables)

    }

    func getHeadlines() {
        newsFetcher.fetchHeadlines(countryCode: countryCode ?? "")
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
                    self.headlinesDataSource = newsModel.articles!.compactMap { ArticlePreviewViewModel(id: ($0.author ?? "")+($0.publishedAt ?? ""), title: $0.title, category: $0.author, imageURL: $0.urlToImage)}
                }
            }
            .store(in: &disposables)
    }

}
