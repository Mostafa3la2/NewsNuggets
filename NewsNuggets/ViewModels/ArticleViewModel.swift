//
//  ArticleViewModel.swift
//  NewsNuggets
//
//  Created by Mostafa Alaa on 26/11/2023.
//

import Combine
import SwiftUI

struct Article: Hashable {
    static func == (lhs: Article, rhs: Article) -> Bool {
        return lhs.id == rhs.id
    }

    var id: String?
    var title: String?
    var category: String?
    var imageURL: String?
    var content: String?
    var publishedAt: String?
    var author: ArticleAuthor?
    var source: String?
    var description: String?

    init(articleGenericMode: ArticleModel) {
        self.id = UUID().uuidString
        self.title = articleGenericMode.title
        self.imageURL = articleGenericMode.image ?? articleGenericMode.urlToImage
        self.content = articleGenericMode.content
        self.publishedAt = articleGenericMode.publishedAt?.toDateTime()?.ddMMMyyyy
        self.author = ArticleAuthor(name: articleGenericMode.author)
        self.source = articleGenericMode.source?.name
        self.description = articleGenericMode.description
    }

    // for preview
    init(id: String?, title: String?, source: String?) {
        self.id = id
        self.title = title
        self.source = source
    }
}

struct ArticleAuthor: Hashable {
    var id: String?
    var name: String?
    var imageURL: String?
}


class NewsViewModel: NSObject, ObservableObject, Identifiable {

    private let newsFetcher: any NewsFetchable
    private var countryCode: String?
    private var disposables = Set<AnyCancellable>()
    @Published var headlinesDataSource: [Article] = []
    init(newsFetcher: some NewsFetchable, locationDataViewModel: LocationRelatedDataViewModel) {
        self.newsFetcher = newsFetcher
        super.init()
        locationDataViewModel.$countryCode
            .sink { [weak self] countryCode in
                self?.countryCode = countryCode?.lowercased()
                self?.getHeadlines(newsFetcher: newsFetcher)
            }
            .store(in: &disposables)
    }

    func getHeadlines(newsFetcher: some NewsFetchable) {
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
                        self.headlinesDataSource = newsModel.articles!.compactMap { Article(articleGenericMode: $0)}
                    }
                }
                .store(in: &disposables)
        }
    }

}
