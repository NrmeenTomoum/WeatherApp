//
//  WeatherRepo.swift
//  WeatherApp
//
//  Created by Nermeen Tomoum on 12/04/2025.
//

import Foundation

protocol WeatherRepoProtocol {
    func getWeather(for weatherRequest: WeatherRequest) async throws -> WeatherResponse
    
}

class WeatherRepo: WeatherRepoProtocol {
    let networkRepository: NetworkProtocol
    
    init(networkRepository: NetworkProtocol = NetworkManager()) {
        self.networkRepository = networkRepository
    }
    
    func getWeather(for weatherRequest: WeatherRequest) async throws -> WeatherResponse {
       do {
           return  try await networkRepository.request(WeatherEndpoint.current(weatherRequest))
        }
        catch {
            fatalError("Error: \(error)")
        }
  
    }
}
