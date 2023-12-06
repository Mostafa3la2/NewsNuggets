//
//  HTTPTask.swift
//  NewsNuggets
//
//  Created by Mostafa Alaa on 06/12/2023.
//

import Foundation

public typealias HTTPHeaders = [String: String]
public typealias Parameters = [String: Any]
public protocol ParameterEncoder {
    func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}
public enum HTTPTask {
    case request

    case requestParameters(bodyParameters: Parameters?,
        bodyEncoding: ParameterEncoding,
        urlParameters: Parameters?)

    case requestParametersAndHeaders(bodyParameters: Parameters?,
        bodyEncoding: ParameterEncoding,
        urlParameters: Parameters?,
        additionHeaders: HTTPHeaders?)

    case requestMultiPart(bodyParameters: Parameters?,
        bodyEncoding: ParameterEncoding,
        urlParameters: Parameters?,
        additionHeaders: HTTPHeaders?,
        imageFile: MultiPartBodyFile?)
}
public struct MultiPartBodyFile {

    var fileData: Data!
    var fileName: String!
    var fileMimeType: String!
    var fileExtension: String!
    init(fileData: Data, name: String!, mimeType: String!, fileExtension: String!) {
        self.fileData = fileData
        self.fileName = name
        self.fileMimeType = mimeType
        self.fileExtension = fileExtension
    }
}
