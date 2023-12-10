//
//  NewsModel.swift
//  NewsNuggets
//
//  Created by Mostafa Alaa on 07/12/2023.
//

import Foundation
// MARK: - NewsModel
struct NewsModel: Codable, NewsGenericModel {

    let status: String?
    let totalResults: Int?
    var articles: [ArticleModel]?
}

// MARK: - Article
struct ArticleModel: Codable {
    let source: Source?
    let author: String?
    let title, description: String?
    let url: String?
    let urlToImage: String?
    let image: String?
    let publishedAt: String?
    let content: String?
}

// MARK: - Source
struct Source: Codable {
    let id: String?
    let name: String?
}
