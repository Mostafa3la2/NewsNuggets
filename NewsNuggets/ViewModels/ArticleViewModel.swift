//
//  ArticleViewModel.swift
//  NewsNuggets
//
//  Created by Mostafa Alaa on 26/11/2023.
//

import Combine
import SwiftUI

protocol ArticleViewModelProtocol {
    var headlinesDataSource: [Article] { get }
    var tailoredNewsDataSource: [Article] { get }
}
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


