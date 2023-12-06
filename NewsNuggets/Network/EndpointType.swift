//
//  EndpointType.swift
//  NewsNuggets
//
//  Created by Mostafa Alaa on 06/12/2023.
//

import Foundation

protocol EndpointType {
    var baseURL: String { get }
    var path: EndpointsPaths? { get }
    var pathArgs: [String]? { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var header: HTTPHeaders { get }

}
extension EndpointType {

    var baseURL: URL {
        guard let url = URL(string: baseURL) else {
            guard let url = URL(string: baseURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
                fatalError("baseURL could not be configured.")
            }
            return url
        }
        return url
    }

    var pathArgs: [String]? {
        return nil
    }

    var requestURL: URL {
        guard let path = path else {
                return baseURL
        }
        return baseURL.appendingPathComponent(path.rawValue.formatted(with: self.pathArgs))
    }
}
