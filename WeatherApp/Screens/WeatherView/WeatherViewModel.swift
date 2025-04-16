//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Nermeen Tomoum on 12/04/2025.
//

import Foundation

@Observable
class WeatherViewModel {
    var weatherUsecase: WeatherUsecaseProtocol
    var weatherType: WeatherType = .none
    var mintemp : String = ""
    var maxtemp : String = ""
    var currenttemp : String = ""
    
    init(weatherUsecase: WeatherUsecaseProtocol = WeatherUsecase()) {
        self.weatherUsecase = weatherUsecase        
    }

    func fetchWeather() {
        Task {
            do {
            let weather = try await weatherUsecase.execute()
                maxtemp = String(format: "%.2f", weather.main.tempMax)
                mintemp = String(format: "%.2f", weather.main.tempMin)
                currenttemp = String(format: "%.2f", weather.main.temp)
                weatherType = weather.weather[0].main
                print(weather.weather[0].description)
                print(weather.name )
                print(weather.main.tempMax,  weather.main.temp , weather.main.tempMin )
                print(weather.weather[0].main)

            } catch {
                print("Error fetching weather data: \(error.localizedDescription)")
            }
        }
    }
}
