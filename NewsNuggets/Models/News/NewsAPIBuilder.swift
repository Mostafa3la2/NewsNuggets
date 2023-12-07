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
}
extension NewsAPIBuilder: EndpointType {
    var parameters: Parameters? {
        switch self {
        case .getHeadlinesForCountry(let countryCode):
            return ["country": countryCode, "apiKey": NEWS_API_KEY]
        }
    }
    var baseURL: String {
        return "https://newsapi.org/v2/"
    }
    
    var path: EndpointsPaths? {
        switch self {
        case .getHeadlinesForCountry:
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
protocol NewsFetchable {
    func fetchHeadlines(countryCode: String) -> AnyPublisher<NewsModel, ApiError>
}

class NewsFetcher: NewsFetchable {
    func fetchHeadlines(countryCode: String) -> AnyPublisher<NewsModel, ApiError> {
        let api = NewsAPIBuilder.getHeadlinesForCountry(countryCode: countryCode)
        return APIManager.sendRequest(api)
    }
}
