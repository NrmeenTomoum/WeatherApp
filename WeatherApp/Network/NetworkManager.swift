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
    
    private let session: URLSession
    private let requestBuilder: RequestBuilder
    
    init(
        session: URLSession = .shared,
        requestBuilder: RequestBuilder = RequestBuilder()
    ) {
        self.session = session
        self.requestBuilder = requestBuilder
    }
    
    func request<T: Decodable>(
        _ endpoint: Endpoint
    ) async throws -> T {
        let request = try requestBuilder.build(from: endpoint)
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.serverError
        }
        
        let statusCode = httpResponse.statusCode
        
        return try WeatherAppResponse(
            data: data,
            statusCode: statusCode
        ).decode(as: T.self)
    }

}



