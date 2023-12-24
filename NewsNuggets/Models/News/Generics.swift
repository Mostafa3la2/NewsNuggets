//
//  Generics.swift
//  NewsNuggets
//
//  Created by Mostafa Alaa on 11/12/2023.
//

import Foundation
import Combine


protocol NewsGenericModel {
    var articles: [ArticleModel]? { get set}
}
protocol NewsFetchable {
    associatedtype T: NewsGenericModel
    func fetchHeadlines(countryCode: String) -> AnyPublisher<T, ApiError>
    func fetchNewsInCategory(countryCode: String, category: String) -> AnyPublisher<T, ApiError>

}
