//
//  WeatherUseCase.swift
//  WeatherApp
//
//  Created by Nermeen Tomoum on 12/04/2025.
//

import Foundation
protocol WeatherUsecaseProtocol {
}
class WeatherUsecase: WeatherUsecaseProtocol{
    private var weatherRepo: WeatherRepoProtocol
    var weatherRequest: WeatherRequest
    
    init(weatherRepo: WeatherRepoProtocol = WeatherRepo(), weatherRequest: WeatherRequest ) {
        self.weatherRepo = weatherRepo
        self.weatherRequest = weatherRequest
    }
    
     func execute() async throws -> WeatherResponse {
         do {
            return  try await weatherRepo.getWeather(for: weatherRequest)
         } catch  {
             throw WeatherError.decodingError(error)
         }
    }
}

 enum WeatherError: Error {
    case networkError(Error)
    case decodingError(Error)
}
