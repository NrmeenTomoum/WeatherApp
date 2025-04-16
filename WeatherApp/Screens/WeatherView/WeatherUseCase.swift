//
//  WeatherUseCase.swift
//  WeatherApp
//
//  Created by Nermeen Tomoum on 12/04/2025.
//

import Foundation
protocol WeatherUsecaseProtocol {
    func execute() async throws -> WeatherResponse
}

class WeatherUsecase: WeatherUsecaseProtocol{

    var weatherRepo: WeatherRepoProtocol
    
    init(weatherRepo: WeatherRepoProtocol = WeatherRepo()) {
        self.weatherRepo = weatherRepo
    }
    
     func execute() async throws -> WeatherResponse {
         do {
            return  try await weatherRepo.getWeather()
         } catch  {
             throw WeatherError.decodingError(error)
         }
    }
}

 enum WeatherError: Error {
    case networkError(Error)
    case decodingError(Error)
}



