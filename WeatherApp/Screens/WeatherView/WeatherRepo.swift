//
//  WeatherRepo.swift
//  WeatherApp
//
//  Created by Nermeen Tomoum on 12/04/2025.
//

import Foundation
import Combine
protocol WeatherRepoProtocol {
    func getWeather() async throws -> WeatherResponse
    
}

class WeatherRepo: WeatherRepoProtocol {
    let networkRepository: NetworkProtocol
    let locationService: LocationServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    init(networkRepository: NetworkProtocol = NetworkManager(),
         locationService: LocationServiceProtocol = LocationService.shared) {
        self.networkRepository = networkRepository
        self.locationService = locationService
    }
    
    
    func getWeather() async throws -> WeatherResponse {

     guard let location = await waitForLocationUpdate() else {
         throw LocationServiceError.unableToObtainLocation
     }
     
     do {
         let weatherRequest = WeatherRequest(lat: location.lat, lon: location.lon, appid: Constant.apiKey)
         return try await networkRepository.request(WeatherEndpoint.current(weatherRequest))
     } catch {
         throw error
     }
 }
 
    private func waitForLocationUpdate() async -> Coord? {
     await withCheckedContinuation { continuation in
         locationService.requestLocationUpdates()
         locationService.currentLocationPublisher
             .compactMap { $0 }
             .first()
             .sink { coord in
                 continuation.resume(returning: Coord(lon: coord.longitude, lat: coord.latitude))
             }
             .store(in: &cancellables)
     }
 }
}
