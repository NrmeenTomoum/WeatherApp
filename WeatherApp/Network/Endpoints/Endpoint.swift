//
//  Endpoint.swift
//  WeatherApp
//
//  Created by Nermeen Tomoum on 12/04/2025.
//
public typealias HTTPHeaders = [String: String]
public typealias HTTPParameters = [String: Any]

enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case PATCH
    case DELETE
}

public enum EncodingTask {
    case plain
    case body(Encodable, WeatherEncoder = WeatherJSONEncoder())
    case url(Encodable, WeatherEncoder = WeatherJSONEncoder())
}



protocol Endpoint {
    var id: String { get }
    var baseURL: String { get }
    var path: String { get }
    var version: String { get }
    var fullURL: String { get }
   // var headers: HTTPHeaders { get }
    var task: EncodingTask { get }
    var method: HTTPMethod { get }
    var authenticationRequired: Bool { get }
    
}


extension Endpoint {
    /// Used in development to identify a request & mock its reponse using Postman
    ///
    /// - Note: It looks like this (`/auth/sign-in:POST`)
    /// - Requires: Development Build Config
    /// - SeeAlso: https://learning.postman.com/docs/designing-and-developing-your-api/mocking-data/matching-algorithm/
    var id: String {
        "/\(path):\(method.rawValue.uppercased())"
    }
    
    var version: String {
        "2.5"
    }
    
    /// Base URL for calling endpoints which is configurable according to Build
    /// Configurations
    var baseURL: String {
       Constant.apiKey
    }

//    var headers: HTTPHeaders {
//        defaultHeaders()
//    }

    var fullURL: String {
        defaultFullURL()
    }
    
}

extension Endpoint {
    
//    func defaultHeaders() -> HTTPHeaders {
//        var headers = [:]
//
//        switch method {
//        case .POST,
//             .PUT,
//             .PATCH:
//            headers["Content-Type"] = "application/json"
//        default:
//            break
//        }
//
//        return headers
//    }

    func defaultFullURL() -> String {
        baseURL + "/\(version)/" + path
    }
}

