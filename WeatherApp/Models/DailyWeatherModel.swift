//
//  DailyWeatherModel.swift
//  WeatherApp
//
//  Created by Nermeen Tomoum on 12/04/2025.
//
import Foundation

struct DailyWeatherModel: Codable, Identifiable {
    var id = UUID()
    let name: String
    let temperature: String
    let weathertype: WeatherType
}
