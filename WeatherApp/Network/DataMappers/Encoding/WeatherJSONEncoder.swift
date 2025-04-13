//
//  WeatherJSONEncoder.swift
//  Weather
//
//  Created by Nermeen Tomoum on 12/04/2025.
//

import Foundation

// MARK: - WeatherJSONEncoder

public final class WeatherJSONEncoder: JSONEncoder, WeatherEncoder {
    override public init() {
        super.init()
        keyEncodingStrategy = .convertToSnakeCase
        dateEncodingStrategy = .iso8601
    }

    public func encode(value: Encodable) throws -> Data {
        try super.encode(value)
    }
}

public extension Encodable {
    func asDictionary(_ encoder: WeatherEncoder = WeatherJSONEncoder()) -> [String: Any] {
        let serialized = (try? JSONSerialization.jsonObject(with: encode(with: encoder), options: .allowFragments)) ?? nil
        return serialized as? [String: Any] ?? [String: Any]()
    }

    func encode(with encoder: WeatherEncoder = WeatherJSONEncoder()) throws -> Data {
        do {
            return try encoder.encode(value: self)
        } catch EncodingError.invalidValue(let value, let context) {
            Log.error("\(value) \(context)", tags: [.encoding])
            throw EncodingError.invalidValue(value, context)
        } catch {
            Log.error("\(error)", tags: [.encoding])
            throw error
        }
    }
}

public extension Dictionary {
    func encode() throws -> Data {
        do {
            return try JSONSerialization.data(withJSONObject: self)
        } catch {
            throw error.whileLogging([.encoding])
        }
    }
}
