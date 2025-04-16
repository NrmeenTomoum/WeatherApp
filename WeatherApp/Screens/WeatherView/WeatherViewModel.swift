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
    var forecastUsecase: Forecast5UsecaseProtocol
    var weatherType: WeatherType = .none
    var mintemp : String = ""
    var maxtemp : String = ""
    var currenttemp : String = ""
    var listOfForecasts: [DailyWeatherModel] = []
    init(weatherUsecase: WeatherUsecaseProtocol = WeatherUsecase(),
         forecastUsecase: Forecast5UsecaseProtocol = Forecast5Usecase()) {
        self.weatherUsecase = weatherUsecase
        self.forecastUsecase = forecastUsecase
    }
    
    func fetchWeather() {
        
        Task {
            do {
                // Fetch forecast and weather concurrently
                async let forecast = forecastUsecase.execute()
                async let weather = weatherUsecase.execute()
                let (forecastResult, weatherResult) = try await (forecast, weather)
                
                // Update UI properties safely
                print(forecastResult.city.name)
                
                listOfForecasts = forecastResult.list.map { item in
                    let date = Date(timeIntervalSince1970: TimeInterval(item.dt))
                    return DailyWeatherModel(
                        name: date.dayOfWeek(),
                        temperature: String(format: "%.2f", item.main.temp),
                        weathertype: item.weather.first?.main ?? .none
                    )
                }
                maxtemp = String(format: "%.2f", weatherResult.main.tempMax)
                mintemp = String(format: "%.2f", weatherResult.main.tempMin)
                currenttemp = String(format: "%.2f", weatherResult.main.temp)
                weatherType = weatherResult.weather.first?.main ?? .none
                
                // Debug prints
                print(weatherResult.weather.first?.description ?? "No description")
                print(weatherResult.name)
                print(weatherResult.main.tempMax, weatherResult.main.temp, weatherResult.main.tempMin)
                print(weatherResult.weather.first?.main ?? .none)
                
            } catch {
                print("Error fetching weather data: \(error.localizedDescription)")
            }
        }
    }
}

extension Date {
    func dayOfWeek() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: self)
    }
}
