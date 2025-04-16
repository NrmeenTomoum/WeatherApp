//
//  Forecast5Usecase.swift
//  WeatherApp
//
//  Created by Nermeen Tomoum on 16/04/2025.
//


//
//  Forecast5Usecase.swift
//  WeatherApp
//
//  Created by Nermeen Tomoum on 12/04/2025.
//

import Foundation
protocol Forecast5UsecaseProtocol {
    func execute() async throws -> ForecastResponse
}

class Forecast5Usecase: Forecast5UsecaseProtocol{

    var forcastRepo: ForecastRepoProtocol
    
    init(forcastRepo: ForecastRepoProtocol = ForecastRepo()) {
        self.forcastRepo = forcastRepo
    }
    
     func execute() async throws -> ForecastResponse {
         do {
            return  try await forcastRepo.getForecast5()
         } catch  {
             throw ForcastError.decodingError(error)
         }
    }
}

 enum ForcastError: Error {
    case networkError(Error)
    case decodingError(Error)
}
