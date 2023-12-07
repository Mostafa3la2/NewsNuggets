//
//  APIManager.swift
//  NewsNuggets
//
//  Created by Mostafa Alaa on 06/12/2023.
//

import Foundation
import Combine


protocol ApiManagerType {
    // can be updated with urlRequest or endpoints
    // T is receiving type as Array or dictionary or decodable
    func fetch<T: Decodable>(url: URL) -> AnyPublisher <T, ApiError>
}



struct APIManager<Endpoint: EndpointType> {
    private var cancellables: [AnyCancellable] = []

    static func sendRequest<P: Codable>(_ endpoint: Endpoint) -> AnyPublisher<P, ApiError> {
        let session = URLSession(configuration: .default)
        do {
            let request = try self.buildRequest(from: endpoint)
            NetworkLogger.log(request: request)
            return session.dataTaskPublisher(for: request)
                .tryMap({ result in
                    guard let httpResponse = result.response as? HTTPURLResponse else {
                        throw ApiError.requestFailed
                    }
                    if (200..<300) ~= httpResponse.statusCode {
                        return result.data
                    }
                    // can handle other erors here
                    throw ApiError.invalidResponse
                })
                .decode(type: P.self, decoder: JSONDecoder())
                .mapError({ error -> ApiError in
                    if let error = error as? ApiError {
                        return error
                    }
                    return ApiError.decodingFailed
                })
                .retry(2)
                .eraseToAnyPublisher()

        } catch {
            return Fail(error: ApiError.badURL).eraseToAnyPublisher()
        }
    }

    static fileprivate func buildRequest(from route: Endpoint) throws -> URLRequest {

        var request = URLRequest(url: route.requestURL,
                                 cachePolicy: .reloadRevalidatingCacheData,
                                 timeoutInterval: 30.0)

        request.httpMethod = route.httpMethod.rawValue

        do {
            switch route.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            case .requestParameters(let bodyParameters,
                                    let bodyEncoding,
                                    let urlParameters):

                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)

            case .requestParametersAndHeaders(let bodyParameters,
                                              let bodyEncoding,
                                              let urlParameters,
                                              let additionalHeaders):

                self.addAdditionalHeaders(additionalHeaders, request: &request)
                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)
            case .requestMultiPart(let bodyParameters, let bodyEncoding, let urlParameters, let additionHeaders, let multipartFile):
                self.addAdditionalHeaders(additionHeaders, request: &request)
                self.configureMultiPart(bodyParameters, bodyEncoding, urlParameters, multipartFile, &request)
            }
            return request
        } catch {
            throw error
        }
    }
    static fileprivate func configureParameters(bodyParameters: Parameters?,
                                         bodyEncoding: ParameterEncoding,
                                         urlParameters: Parameters?,
                                         request: inout URLRequest) throws {
        do {
            try bodyEncoding.encode(urlRequest: &request,
                                    bodyParameters: bodyParameters, urlParameters: urlParameters)
        } catch {
            throw error
        }
    }
    static fileprivate func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    static fileprivate func configureMultiPart(_ bodyParameters: Parameters?,
                                        _ bodyEncoding: ParameterEncoding,
                                        _ urlParameters: Parameters?,
                                        _ multiPartFile: MultiPartBodyFile?,
                                        _ request: inout URLRequest) {
        let body = NSMutableData()
        let boundary = generateBoundaryString()

        if let bodyParameters = bodyParameters {
            for (key, value) in bodyParameters {
                if let value = value as? String {
                    body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                    body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
                    body.append("\(value)\r\n".data(using: String.Encoding.utf8)!)
                }
            }
        }
        if let file = multiPartFile {
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition:form-data; name=\"\(file.fileName!)\"; filename=\"\(file.fileName!).\(file.fileExtension!)\"\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Type: \(file.fileMimeType!)\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append(file.fileData!)
            body.append("\r\n".data(using: String.Encoding.utf8)!)
        }
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = body as Data
    }
    static fileprivate func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
}
