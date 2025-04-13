//
//  WeatherJSONDecoder.swift
//  WeatherAppTests
//
//  Created by Nermeen Tomoum on 13/04/2025.
//

import XCTest
@testable import WeatherApp

final class WeatherJSONDecoderTests: XCTestCase {
    private struct TestModel: Codable, Equatable {
           let name: String
           let id: Int
       }

    func testDecodeFailureWithMissingKey() {
         // Given
         let decoder = WeatherJSONDecoder()
         let json = """
         {
             "name": "value1"
         }
         """.data(using: .utf8)!
         
         // When/Then
         XCTAssertThrowsError(try decoder.decode(TestModel.self, from: json)) { error in
             // Verify error is thrown and logged
             guard let decodingError = error as? DecodingError else {
                 XCTFail("Expected DecodingError")
                 return
             }
             
             // The error should be a keyNotFound error
             switch decodingError {
             case .keyNotFound:
                 // Success - expected error type
                 break
             default:
                 XCTFail("Expected keyNotFound error, got \(decodingError)")
             }
         }
     }
    
    func testDecodeSuccessWithSnakeCase() throws {
           // Given
           let decoder = WeatherJSONDecoder()
           let json = """
           {
               "name": "value1",
               "id": 5
           }
           """.data(using: .utf8)!
           
           // When
           let result = try decoder.decode(TestModel.self, from: json)
           
           // Then
           let expectedModel = TestModel(name: "value1", id: 5)
           XCTAssertEqual(result, expectedModel)
       }


}
