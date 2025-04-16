//
//  Network.swift
//  WeatherApp
//
//  Created by Nermeen Tomoum on 12/04/2025.
//

import Foundation

protocol NetworkProtocol {
    func request<T: Decodable>(
        _ endpoint: Endpoint
    ) async throws -> T
}

final class NetworkManager : NetworkProtocol {
    
    private let session: URLSessionProtocol
    private let requestBuilder: RequestBuilding
    
    init(
        session: URLSessionProtocol = URLSession.shared,
        requestBuilder: RequestBuilding = RequestBuilder()
    ) {
        self.session = session
        self.requestBuilder = requestBuilder
    }
    
    func request<T: Decodable>(
        _ endpoint: Endpoint
    ) async throws -> T {
        let request = try requestBuilder.build(from: endpoint)
        let (data, response) = try await session.data(for: request, delegate: nil)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.serverError
        }
        
        return try WeatherAppResponse(
            data: data,
            statusCode: httpResponse.statusCode
        ).decode(as: T.self)
    }

}



