//
//  WeatherRequest.swift
//  WeatherApp
//
//  Created by Nermeen Tomoum on 12/04/2025.
//


struct WeatherRequest: Encodable {
    let lat: Double
    let lon: Double
    let appid: String
}