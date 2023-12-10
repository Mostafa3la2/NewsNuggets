//
//  GNewsModel.swift
//  NewsNuggets
//
//  Created by Mostafa Alaa on 10/12/2023.
//

import Foundation

// MARK: - NewsModel
struct GNewsModel: Codable, NewsGenericModel {

    let totalArticles: Int?
    var articles: [ArticleModel]?
}


