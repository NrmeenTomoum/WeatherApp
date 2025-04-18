//
//  WeatherEndpoint.swift
//  WeatherApp
//
//  Created by Nermeen Tomoum on 12/04/2025.
//
enum WeatherEndpoint {
    case current(WeatherRequest)
    case forecast5(WeatherRequest)
}

extension WeatherEndpoint: Endpoint {
    
    var authenticationRequired: Bool {
        switch self {
        case .current(_):
            false
        case .forecast5(_):
            false
        }
    }
    
    var method: HTTPMethod { .GET }
    
    var task: EncodingTask {
        switch self {
        case .current(let weather):
            var parameters = [String: String]()
            parameters["lat"] = "\(weather.lat)"
            parameters["lon"] = "\(weather.lon)"
            parameters["appid"] = weather.appid
            parameters["units"] = "metric"
            return .url(parameters)
            
        case .forecast5(let weather):
            var parameters = [String: String]()
            parameters["lat"] = "\(weather.lat)"
            parameters["lon"] = "\(weather.lon)"
            parameters["appid"] = weather.appid
            parameters["units"] = "metric"
            parameters["cnt"] = "5"
            return .url(parameters)
        }
    }
    
    var path: String {
        switch self {
        case .current(_):
            return "weather?"
        case .forecast5(_):
            return "forecast?"
        }
    }
}
