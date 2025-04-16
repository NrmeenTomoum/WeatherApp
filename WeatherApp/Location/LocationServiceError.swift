//
//  LocationServiceError.swift
//  WeatherApp
//
//  Created by Nermeen Tomoum on 15/04/2025.
//

import Foundation
enum LocationServiceError: Error, LocalizedError, Equatable {
    case unauthorized
    case locationServicesDisabled
    case unableToObtainLocation
    
    var errorDescription: String? {
        switch self {
        case .unauthorized:
            return "Location access is not authorized. Please enable location access in Settings."
        case .locationServicesDisabled:
            return "Location services are disabled. Please enable location services in Settings."
        case .unableToObtainLocation:
            return "Unable to obtain location. Please try again later."
        }
    }
}
