//
//  ArticleViewModel.swift
//  NewsNuggets
//
//  Created by Mostafa Alaa on 26/11/2023.
//

import Foundation

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
