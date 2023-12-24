//
//  NewsAPIBuilder.swift
//  NewsNuggets
//
//  Created by Mostafa Alaa on 07/12/2023.
//

import Foundation
import Combine

enum NewsAPIBuilder {
    case getHeadlinesForCountry(countryCode: String)
    case getNewsInCategory(countryCode: String, category: String)

}
extension NewsAPIBuilder: EndpointType {
    var parameters: Parameters? {
        switch self {
        case .getHeadlinesForCountry(let countryCode):
            return ["country": countryCode, "apiKey": NEWS_API_KEY]
        case .getNewsInCategory(let countryCode, let category):
            return ["country": countryCode, "category": category, "apiKey": NEWS_API_KEY]
        }
    }
    var baseURL: String {
        return "https://newsapi.org/v2/"
    }
    
    var path: EndpointsPaths? {
        switch self {
        case .getHeadlinesForCountry, .getNewsInCategory:
            return .headlines
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        return .requestParameters(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: parameters)
    }
    
    var header: HTTPHeaders {
        return [:]

    }
}
class NewsFetcher: NewsFetchable {
    func fetchNewsInCategory(countryCode: String, category: String) -> AnyPublisher<NewsModel, ApiError> {
        let api = NewsAPIBuilder.getNewsInCategory(countryCode: countryCode, category: category)
        return APIManager.sendRequest(api)
    }
    

    typealias T = NewsModel
    func fetchHeadlines(countryCode: String) -> AnyPublisher<T, ApiError> {
        let api = NewsAPIBuilder.getHeadlinesForCountry(countryCode: countryCode)
        return APIManager.sendRequest(api)
    }
}
