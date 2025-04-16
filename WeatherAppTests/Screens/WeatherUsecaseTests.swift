//
//  WeatherUsecaseTests.swift
//  WeatherApp
//
//  Created by Nermeen Tomoum on 16/04/2025.
//


import XCTest
@testable import WeatherApp
enum MockError: Error {
    case decodingFailed
    case jsonNotFound
}

class MockWeatherRepoSuccess: WeatherRepoProtocol {
    

    func getWeather() async throws -> WeatherResponse {
 
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
}

class MockWeatherRepoFailure: WeatherRepoProtocol {
    
    func getWeather() async throws -> WeatherResponse {
        throw MockError.decodingFailed
    }
}

final class WeatherUsecaseTests: XCTestCase {
    
    func testExecute_ReturnsWeatherResponse_OnSuccess() async throws {
        // Given
        let usecase = WeatherUsecase(weatherRepo: MockWeatherRepoSuccess())
        
        // When
        let result = try await usecase.execute()
        
        // Then
        XCTAssertEqual(result.main.temp, 8.38)
        XCTAssertEqual(result.weather[0].main, WeatherType.cloudy)
    }
    
    func testExecute_ThrowsDecodingError_OnFailure() async {
        // Given
        let usecase = WeatherUsecase(weatherRepo: MockWeatherRepoFailure())
        
        // When & Then
        do {
            _ = try await usecase.execute()
            XCTFail("Expected error to be thrown")
        } catch let error as WeatherError {
            if case .decodingError = error {
                // success
            } else {
                XCTFail("Expected .decodingError, got \(error)")
            }
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
}


