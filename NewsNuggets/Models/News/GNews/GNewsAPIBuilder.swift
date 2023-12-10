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
}
extension GNewsAPIBuilder: EndpointType {
    var parameters: Parameters? {
        switch self {
        case .getHeadlinesForCountry(let countryCode):
            return ["country": countryCode, "apikey": GNEWS_API_KEY]
        }
    }
    var baseURL: String {
        return "https://gnews.io/api/v4/"
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

class GNewsFetcher: NewsFetchable {

    typealias T = GNewsModel
    func fetchHeadlines(countryCode: String) -> AnyPublisher<T, ApiError> {
        let api = GNewsAPIBuilder.getHeadlinesForCountry(countryCode: countryCode)
        return APIManager.sendRequest(api)
    }
}
