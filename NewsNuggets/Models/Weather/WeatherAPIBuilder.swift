//
//  WeatherAPIBuilder.swift
//  NewsNuggets
//
//  Created by Mostafa Alaa on 07/12/2023.
//

import Foundation
import Combine
enum WeatherAPIBuilder {
    case getCurrentWeatherDataForLocation(lat: String, long: String)
}

extension WeatherAPIBuilder: EndpointType {
    var parameters: Parameters? {
        switch self {
        case .getCurrentWeatherDataForLocation(let lat, let long):
            return ["lat": lat, "lon": long, "appid": WEATHER_API_KEY, "units": "metric"]
        }
    }
    var path: EndpointsPaths? {
        switch self {
        case .getCurrentWeatherDataForLocation:
            return .currentWeather
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
    
    var baseURL: String {
        return "https://api.openweathermap.org/data/2.5/"
    }
}


// this acts as a wrapper for generic type by returning the model instead of generic type in AnyPublisher<Model, error>, now we can have a publisher with the specified type
protocol WeatherFetchable {
    func fetchWeather(forLat lat: String, andLong lon: String) -> AnyPublisher<WeatherModel, ApiError>
}

class WeatherFetcher: WeatherFetchable {
    func fetchWeather(forLat lat: String, andLong lon: String) -> AnyPublisher<WeatherModel, ApiError> {
        let api = WeatherAPIBuilder.getCurrentWeatherDataForLocation(lat: lat, long: lon)
        return APIManager.sendRequest(api)
    }
}
