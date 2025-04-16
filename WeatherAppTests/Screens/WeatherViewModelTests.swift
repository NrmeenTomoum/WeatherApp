//
//  WeatherViewModelTests.swift
//  WeatherApp
//
//  Created by Nermeen Tomoum on 16/04/2025.
//


import XCTest
import Combine
@testable import WeatherApp

func getWeather() throws -> WeatherResponse {
    
    guard let bundle = Bundle(identifier: "nermeen.tomoum.WeatherAppTests"),
          let path = bundle.path(forResource: "weatherResponse", ofType: "json") else {
        throw MockError.jsonNotFound
    }
    do {
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        let response = try JSONDecoder().decode(WeatherResponse.self, from: data)
        return response
    } catch {
        throw MockError.decodingFailed
    }
}

final class WeatherViewModelTests: XCTestCase {
    
    class MockWeatherUsecase: WeatherUsecaseProtocol {
        var mockResponse: WeatherResponse
        
        init(mockResponse: WeatherResponse) {
            self.mockResponse = mockResponse
        }
        
        func execute() async throws -> WeatherResponse {
            return mockResponse
        }
    }
    
    func testFetchWeather_success_setsTempsAndType() async throws {
        // Given
        let mockWeather = try getWeather()
        
        let viewModel = WeatherViewModel(weatherUsecase: MockWeatherUsecase(mockResponse: mockWeather))
        
        // When
        await viewModel.fetchWeather()
        print(viewModel.maxtemp)
        // Then
        XCTAssertEqual(viewModel.maxtemp, String(format: "%.2f", mockWeather.main.tempMax))
        XCTAssertEqual(viewModel.mintemp, String(format: "%.2f", mockWeather.main.tempMin)) // Removed leading space
        XCTAssertEqual(viewModel.currenttemp, String(format: "%.2f", mockWeather.main.temp))
        XCTAssertEqual(viewModel.weatherType, mockWeather.weather[0].main)
    }
    
    func testFetchWeather_failure_doesNotUpdateTempsOrType() async {
        // Given
        class FailingWeatherUsecase: WeatherUsecaseProtocol {
            func execute() async throws -> WeatherResponse {
                throw WeatherError.decodingError(MockError.decodingFailed)
            }
        }
        
        let viewModel = WeatherViewModel(weatherUsecase: FailingWeatherUsecase())
        
        // When
        await viewModel.fetchWeather()
        
        // Then
        XCTAssertEqual(viewModel.maxtemp, "")
        XCTAssertEqual(viewModel.mintemp, "")
        XCTAssertEqual(viewModel.currenttemp, "")
        XCTAssertEqual(viewModel.weatherType, .none)
    }
    
}
