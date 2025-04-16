//
//  WeatherTypes.swift
//  WeatherApp
//
//  Created by Nermeen Tomoum on 12/04/2025.
//

import Foundation

enum WeatherType: String, Codable {
    case sunny = "Clear"
    case cloudy = "Clouds"
    case rain = "Rain"
    case none
}

extension WeatherType {
    var name: String {
        switch self {
        case .sunny:
            return "SUNNY"
        case .cloudy:
            return "CLOUDY"
        case .rain:
            return "RAINY"
        case .none:
            return  "Please add this weather type"
        }
    }
    
    var iconName: String {
        switch self {
        case .sunny:
            return "sunny"
        case .cloudy:
            return "cloudy"
        case .rain:
            return "rainy"
        case .none:
            return "Gobal"
        }
    }
    
    var backgroundpicture: String {
        switch self {
        case .sunny:
            return "forest_sunny"
        case .cloudy:
            return "forest_cloudy"
        case .rain:
            return "forest_rainy"
        case .none:
            return "Gobal"
        }
    }
}
