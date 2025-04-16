//
//  ForecastRepo.swift
//  WeatherApp
//
//  Created by Nermeen Tomoum on 16/04/2025.
//


//
//  ForcastRepo.swift
//  WeatherApp
//
//  Created by Nermeen Tomoum on 12/04/2025.
//

import Foundation
import Combine
protocol ForecastRepoProtocol {
    func getForecast5() async throws -> ForecastResponse
}

class ForecastRepo: ForecastRepoProtocol {
    let networkRepository: NetworkProtocol
    let locationService: LocationServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    init(networkRepository: NetworkProtocol = NetworkManager(),
         locationService: LocationServiceProtocol = LocationService.shared) {
        self.networkRepository = networkRepository
        self.locationService = locationService
    }
    
    
    func getForecast5() async throws -> ForecastResponse {

     guard let location = await waitForLocationUpdate() else {
         throw LocationServiceError.unableToObtainLocation
     }
     
     do {
         let weatherRequest = WeatherRequest(lat: location.lat, lon: location.lon, appid: Constant.apiKey)
         
         let forecast: ForecastResponse = try await networkRepository.request(WeatherEndpoint.forecast5(weatherRequest))
         print(forecast)
         return forecast
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
