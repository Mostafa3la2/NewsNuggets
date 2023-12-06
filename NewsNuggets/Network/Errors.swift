//
//  Errors.swift
//  NewsNuggets
//
//  Created by Mostafa Alaa on 06/12/2023.
//

import Foundation

enum ApiError: Error {
    case badURL
    case requestFailed
    case invalidResponse
    case decodingFailed
    case encodingFailed
    case customError(ErrorModel)
    var errorDescription: String? {
        switch self {
        case .requestFailed:
            return "Server is not reachable"
        case .badURL:
            return "Not a valid URL"
        case .decodingFailed:
            return "Json failed"
        case .encodingFailed:
            return "encoding failed"
        case .invalidResponse:
            return "Response type not a json"
        case .customError(let model):
            return model.message
        }
    }
}

// for custom erors
struct ErrorModel: Codable {
    let code: String?
    let message: String?
}
