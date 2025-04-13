//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Nermeen Tomoum on 12/04/2025.
//

import Foundation

@Observable
class WeatherViewModel {
     var weatherModel: Weather?

    var weatherUsecase: WeatherUsecaseProtocol
    
    init(weatherUsecase: WeatherUsecaseProtocol = WeatherUsecase(weatherRequest: WeatherRequest(lat: 31.2357, lon: 30.0444, appid: Constant.apiKey))) {
        self.weatherUsecase = weatherUsecase
    }
    
    
    func fetchWeather() {
//        weatherUsecase.execute { [weak self] result in
//            
//        }
    }
}
