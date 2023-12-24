//
//  GNewsAPIBuilder.swift
//  NewsNuggets
//
//  Created by Mostafa Alaa on 10/12/2023.
//

import Foundation

import Combine

enum GNewsAPIBuilder{
    case getHeadlinesForCountry(countryCode: String)
    case getNewsInCategory(countryCode: String, category: String)
}
extension GNewsAPIBuilder: EndpointType {
    var parameters: Parameters? {
        switch self {
        case .getHeadlinesForCountry(let countryCode):
            return ["country": countryCode, "apikey": GNEWS_API_KEY]
        case .getNewsInCategory(let countryCode, let category):
            return ["country": countryCode, "category": category, "apikey": GNEWS_API_KEY]
        }
    }
    var baseURL: String {
        return "https://gnews.io/api/v4/"
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

class GNewsFetcher: NewsFetchable {

    typealias T = GNewsModel
    func fetchHeadlines(countryCode: String) -> AnyPublisher<T, ApiError> {
        let api = GNewsAPIBuilder.getHeadlinesForCountry(countryCode: countryCode)
        return APIManager.sendRequest(api)
    }
    func fetchNewsInCategory(countryCode: String, category: String) -> AnyPublisher<T, ApiError> {
        let api = GNewsAPIBuilder.getNewsInCategory(countryCode: countryCode, category: category)
        return APIManager.sendRequest(api)
    }
}
