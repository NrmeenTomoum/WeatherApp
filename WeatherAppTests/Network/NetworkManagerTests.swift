//
//  NetworkManagerTests.swift
//  WeatherAppTests
//
//  Created by Nermeen Tomoum on 13/04/2025.
//

import XCTest
@testable import WeatherApp

final class NetworkManagerTests: XCTestCase {
    // MARK: - Mock Classes
      
    class MockURLSession: URLSessionProtocol {
          var dataToReturn: Data
          var responseToReturn: URLResponse
          var errorToThrow: Error?
          var capturedRequest: URLRequest?
          
          init(dataToReturn: Data, responseToReturn: URLResponse, errorToThrow: Error? = nil) {
              self.dataToReturn = dataToReturn
              self.responseToReturn = responseToReturn
              self.errorToThrow = errorToThrow
          }
        
        public func data(for request: URLRequest, delegate: (any URLSessionTaskDelegate)? = nil) async throws -> (Data, URLResponse)
          {
              capturedRequest = request
              
              if let error = errorToThrow {
                  throw error
              }
              
              return (dataToReturn, responseToReturn)
          }
      }
      
    struct MockRequestBuilder: RequestBuilding {
          var requestToReturn: URLRequest
          
          init(requestToReturn: URLRequest) {
              self.requestToReturn = requestToReturn
          }
          
        func build(from endpoint: Endpoint) throws -> URLRequest {
              return requestToReturn
          }
      }
      
    struct MockModel: Codable, Equatable {
          let id: Int
          let name: String
      }
      
      // Mock endpoint
    struct MockEndpoint: Endpoint {
        var task: EncodingTask
        
        var authenticationRequired: Bool
        
          var path: String
          var method: HTTPMethod
          var headers: [String: String]?
          var queryParams: [String: String]?
          var body: Encodable?
      }
      
      // MARK: - Tests for Response Handling
      
      func testSuccessfulResponse() async throws {
          // Given
          let mockModel = MockModel(id: 123, name: "Test")
          let jsonData = try JSONEncoder().encode(mockModel)
          
          let httpResponse = HTTPURLResponse(
              url: URL(string: "https://example.com")!,
              statusCode: 200,
              httpVersion: nil,
              headerFields: ["Content-Type": "application/json"]
          )!
          
          let mockSession = MockURLSession(
              dataToReturn: jsonData,
              responseToReturn: httpResponse
          )
          
          let mockRequest = URLRequest(url: URL(string: "https://example.com/test")!)
          let mockRequestBuilder = MockRequestBuilder(requestToReturn: mockRequest)
          
          let networkManager = NetworkManager(
              session: mockSession,
              requestBuilder: mockRequestBuilder
          )
          var parameters = [String: String]()
          parameters["lat"] = "3456"
          parameters["lon"] = "54678"
          
          let endpoint = MockEndpoint(
            task: .url(parameters),
            authenticationRequired: false,
            path: "/test",
              method: .GET,
              headers: nil,
              queryParams: nil,
              body: nil
          )
          
          // When
          let result: MockModel = try await networkManager.request(endpoint)
          
          // Then
          XCTAssertEqual(result, mockModel)
          XCTAssertNotNil(mockSession.capturedRequest)
      }
      
      func testDifferentResponseStatusCodes() async throws {
          let testCases = [
              (200, true),  // Success - should not throw
              (201, true),  // Created - should not throw
              (400, false), // Bad Request - should throw
              (401, false), // Unauthorized - should throw
              (404, false), // Not Found - should throw
              (500, false)  // Server Error - should throw
          ]
          
          for (statusCode, shouldSucceed) in testCases {
              // Given
              let mockModel = MockModel(id: 123, name: "Test")
              let jsonData = try JSONEncoder().encode(mockModel)
              
              let httpResponse = HTTPURLResponse(
                  url: URL(string: "https://example.com")!,
                  statusCode: statusCode,
                  httpVersion: nil,
                  headerFields: ["Content-Type": "application/json"]
              )!
              
              let mockSession = MockURLSession(
                  dataToReturn: jsonData,
                  responseToReturn: httpResponse
              )
              
              let mockRequest = URLRequest(url: URL(string: "https://example.com/test")!)
              let mockRequestBuilder = MockRequestBuilder(requestToReturn: mockRequest)
              
              let networkManager = NetworkManager(
                  session: mockSession,
                  requestBuilder: mockRequestBuilder
              )
              var parameters = [String: String]()
              parameters["lat"] = "3456"
              parameters["lon"] = "54678"
              
              let endpoint = MockEndpoint(
                task: .url(parameters),
                authenticationRequired: false,
                  path: "/test",
                method: .GET,
                  headers: nil,
                  queryParams: nil,
                  body: nil
              )
              
              // When/Then
              if shouldSucceed {
                  // Should not throw for success codes
                  do {
                      let result: MockModel = try await networkManager.request(endpoint)
                      XCTAssertEqual(result, mockModel, "Expected successful decode for status code \(statusCode)")
                  } catch {
                      XCTFail("Should not throw error for status code \(statusCode), but got: \(error)")
                  }
              } else {
                  // Should throw for error codes
                  do {
                      let _: MockModel = try await networkManager.request(endpoint)
                      XCTFail("Expected error for status code \(statusCode) but request succeeded")
                  } catch {
                      // Success - error was thrown as expected
                      // You could add more specific assertions about error types if needed
                  }
              }
          }
      }
      
      func testNonHTTPResponse() async {
          // Given
          let nonHTTPResponse = URLResponse(
              url: URL(string: "https://example.com")!,
              mimeType: "application/json",
              expectedContentLength: 0,
              textEncodingName: nil
          )
          
          let mockSession = MockURLSession(
              dataToReturn: Data(),
              responseToReturn: nonHTTPResponse
          )
          
          let mockRequest = URLRequest(url: URL(string: "https://example.com/test")!)
          let mockRequestBuilder = MockRequestBuilder(requestToReturn: mockRequest)
          
          let networkManager = NetworkManager(
              session: mockSession,
              requestBuilder: mockRequestBuilder
          )
          var parameters = [String: String]()
          parameters["lat"] = "3456"
          parameters["lon"] = "54678"
          
          let endpoint = MockEndpoint(
            task: .url(parameters),
            authenticationRequired: false,
              path: "/test",
            method: .GET,
              headers: nil,
              queryParams: nil,
              body: nil
          )
          
          // When/Then
          do {
              let _: MockModel = try await networkManager.request(endpoint)
              XCTFail("Expected error for non-HTTP response")
          } catch let error as NetworkError {
              XCTAssertEqual(error.errorDescription, NetworkError.serverError.errorDescription)
          } catch {
              XCTFail("Expected NetworkError.serverError, but got: \(error)")
          }
      }
      
      func testEmptyResponseData() async {
          // Given
          let emptyData = Data()
          
          let httpResponse = HTTPURLResponse(
              url: URL(string: "https://example.com")!,
              statusCode: 200,
              httpVersion: nil,
              headerFields: ["Content-Type": "application/json"]
          )!
          
          let mockSession = MockURLSession(
              dataToReturn: emptyData,
              responseToReturn: httpResponse
          )
          
          let mockRequest = URLRequest(url: URL(string: "https://example.com/test")!)
          let mockRequestBuilder = MockRequestBuilder(requestToReturn: mockRequest)
          
          let networkManager = NetworkManager(
              session: mockSession,
              requestBuilder: mockRequestBuilder
          )
          var parameters = [String: String]()
          parameters["lat"] = "3456"
          parameters["lon"] = "54678"
          
          let endpoint = MockEndpoint(
            task: .url(parameters),
            authenticationRequired: false,
              path: "/test",
              method: .GET,
              headers: nil,
              queryParams: nil,
              body: nil
          )
          
          // When/Then
          do {
              let _: MockModel = try await networkManager.request(endpoint)
              XCTFail("Expected error for empty response data")
          } catch {
              
          }
      }
      
      func testMalformedJSONResponse() async {
          // Given
          let malformedJSON = "{ this is not valid json }".data(using: .utf8)!
          
          let httpResponse = HTTPURLResponse(
              url: URL(string: "https://example.com")!,
              statusCode: 200,
              httpVersion: nil,
              headerFields: ["Content-Type": "application/json"]
          )!
          
          let mockSession = MockURLSession(
              dataToReturn: malformedJSON,
              responseToReturn: httpResponse
          )
          
          let mockRequest = URLRequest(url: URL(string: "https://example.com/test")!)
          let mockRequestBuilder = MockRequestBuilder(requestToReturn: mockRequest)
          
          let networkManager = NetworkManager(
              session: mockSession,
              requestBuilder: mockRequestBuilder
          )
          var parameters = [String: String]()
          parameters["lat"] = "3456"
          parameters["lon"] = "54678"
          
          let endpoint = MockEndpoint(
            task: .url(parameters),
            authenticationRequired: false,
              path: "/test",
            method: .GET,
              headers: nil,
              queryParams: nil,
              body: nil
          )
          
          // When/Then
          do {
              let _: MockModel = try await networkManager.request(endpoint)
              XCTFail("Expected error for malformed JSON")
          } catch {
          }
      }
      
      func testValidJSONButWrongStructure() async {
          // Given
          // JSON is valid but doesn't match our expected model structure
          let differentStructureJSON = """
          {
              "different": "structure",
              "than": "expected"
          }
          """.data(using: .utf8)!
          
          let httpResponse = HTTPURLResponse(
              url: URL(string: "https://example.com")!,
              statusCode: 200,
              httpVersion: nil,
              headerFields: ["Content-Type": "application/json"]
          )!
          
          let mockSession = MockURLSession(
              dataToReturn: differentStructureJSON,
              responseToReturn: httpResponse
          )
          
          let mockRequest = URLRequest(url: URL(string: "https://example.com/test")!)
          let mockRequestBuilder = MockRequestBuilder(requestToReturn: mockRequest)
          
          let networkManager = NetworkManager(
              session: mockSession,
              requestBuilder: mockRequestBuilder
          )
          
          var parameters = [String: String]()
          parameters["lat"] = "3456"
          parameters["lon"] = "54678"
          
          let endpoint = MockEndpoint(
            task: .url(parameters),
            authenticationRequired: false,
              path: "/test",
            method: .GET,
              headers: nil,
              queryParams: nil,
              body: nil
          )
          
          // When/Then
          do {
              let _: MockModel = try await networkManager.request(endpoint)
              XCTFail("Expected error for JSON with wrong structure")
          } catch {
              // Success - error was thrown
              // Could add assertions to check if it's a DecodingError
          }
      }
      
      func testNetworkConnectionError() async {
          // Given
          struct MockNetworkError: Error {}
          
          let mockSession = MockURLSession(
              dataToReturn: Data(),
              responseToReturn: HTTPURLResponse(),
              errorToThrow: MockNetworkError()
          )
          
          let mockRequest = URLRequest(url: URL(string: "https://example.com/test")!)
          let mockRequestBuilder = MockRequestBuilder(requestToReturn: mockRequest)
          
          let networkManager = NetworkManager(
              session: mockSession,
              requestBuilder: mockRequestBuilder
          )
          var parameters = [String: String]()
          parameters["lat"] = "3456"
          parameters["lon"] = "54678"
          
          let endpoint = MockEndpoint(
            task: .url(parameters),
            authenticationRequired: false,
              path: "/test",
              method: .GET,
              headers: nil,
              queryParams: nil,
              body: nil
          )
          
          // When/Then
          do {
              let _: MockModel = try await networkManager.request(endpoint)
              XCTFail("Expected error for network connection failure")
          } catch is MockNetworkError {
              // Success - the specific error was propagated correctly
          } catch {
              XCTFail("Expected MockNetworkError but got: \(error)")
          }
      }
  }
