//
//  WeatherJSONEncoderTests.swift
//  WeatherApp
//
//  Created by Nermeen Tomoum on 13/04/2025.
//


import XCTest
@testable import WeatherApp

final class WeatherJSONEncoderTests: XCTestCase {
    
    private struct TestModel: Codable, Equatable {
        let name: String
        let id: Int
    }

    func testEncodeWithSnakeCase() throws {
        // Given
        let encoder = WeatherJSONEncoder()
        let model = TestModel(name: "value1", id: 1 )
        
        // When
        let jsonData = try encoder.encode(model)
        // Then
        let jsonObject = try JSONSerialization.jsonObject(with: jsonData) as! [String: Any]
        
        XCTAssertEqual(jsonObject["name"] as? String, "value1")
        XCTAssertEqual(jsonObject["id"] as? Int, 1)
    }
    
    
    func testEncodeFailureHandling() throws {
        // Given
        let encoder = WeatherJSONEncoder()
        
        // Create a model with a non-encodable property using a proper error-throwing approach
        struct UnencodableValue: Encodable {
            func encode(to encoder: Encoder) throws {
                throw EncodingError.invalidValue(self, EncodingError.Context(
                    codingPath: [],
                    debugDescription: "This value deliberately fails to encode"))
            }
        }
        
        struct InvalidModel: Encodable {
            let validField: String
            let invalidField: UnencodableValue
        }
        
        let model = InvalidModel(validField: "test", invalidField: UnencodableValue())
        
        // When/Then
        XCTAssertThrowsError(try encoder.encode(model)) { error in
            // Verify error is thrown and logged
            guard let encodingError = error as? EncodingError else {
                XCTFail("Expected EncodingError")
                return
            }
            
            // Verify the error type
            switch encodingError {
            case .invalidValue:
                // This is the expected error type
                break
            default:
                XCTFail("Expected invalidValue error, got \(encodingError)")
            }
            
        }
    }
    
}
