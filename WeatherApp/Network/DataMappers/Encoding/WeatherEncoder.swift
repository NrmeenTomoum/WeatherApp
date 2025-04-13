import Foundation

public protocol WeatherEncoder {
    func encode(value: Encodable) throws -> Data
}
