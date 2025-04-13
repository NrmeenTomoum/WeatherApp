//
//  Logger.swift
//  Weather
//
//  Created by Nermeen Tomoum on 12/04/2025.
//

import Foundation

// MARK: - Logger

public protocol Logger {
    func info(message: String, tags: [LogTag], file: String, function: String, metadata: [String: String])
    func warn(message: String, tags: [LogTag], file: String, function: String, metadata: [String: String])
    func error(message: String, tags: [LogTag], file: String, function: String, metadata: [String: String])
}

extension Logger {
    func info(message: String, tags: [LogTag], file: String, function: String) {
        info(message: message, tags: tags, file: file, function: function, metadata: [:])
    }
    
    func warn(message: String, tags: [LogTag], file: String, function: String) {
        warn(message: message, tags: tags, file: file, function: function, metadata: [:])
    }
    
    func error(message: String, tags: [LogTag], file: String, function: String) {
        error(message: message, tags: tags, file: file, function: function, metadata: [:])
    }
}

// MARK: - LogTag

public struct LogTag: Equatable {
    public let rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

public extension LogTag {
    static let `internal`: LogTag = .init(rawValue: "[Internal]")
    static let parsing: LogTag = .init(rawValue: "[Parsing]")
    static let encoding: LogTag = .init(rawValue: "[Encoding]")
    static let authentication: LogTag = .init(rawValue: "[Authentication]")
    static let network: LogTag = .init(rawValue: "[Network]")
    static let location: LogTag = .init(rawValue: "[Location]")
    static let locationService: LogTag = .init(rawValue: "[Location Service]")
    static let lifecycle: LogTag = .init(rawValue: "[Lifecycle]")
}

// MARK: - Loggable

public protocol Loggable: CustomDebugStringConvertible { }

public extension Error {
    /// Side-effects the error logging and returning the error unchanged
    /// - Parameter tags: Tags needed to filter the error if needed
    /// - Returns: returns the error without changes
    func whileLogging(
        _ tags: [LogTag] = [],
        _ metadata: [String: String] = [:],
        file: String = #file,
        function: String = #function
    ) -> Self {
        log(tags, metadata, file: file, function: function)
        return self
    }
    
    /// Side-effects the error logging
    /// - Parameter tags: Tags needed to filter the error if needed
    func log(
        _ tags: [LogTag] = [],
        _ metadata: [String: String] = [:],
        file: String = #file,
        function: String = #function
    ) {
        Log.error(debugDescription, tags: tags, file: file, function: function, metadata: metadata)
    }
    
    var debugDescription: String {
        if let loggableError = self as? Loggable {
            return loggableError.debugDescription
        } else {
            let nsError = self as NSError
            var errorInfo = ""
            if let localizedFailureReason = nsError.userInfo[NSLocalizedFailureReasonErrorKey] as? String {
                errorInfo += "\nFailure Reason: \(localizedFailureReason)"
            }
            
            if let localizedRecoverySuggestion = nsError.userInfo[NSLocalizedRecoverySuggestionErrorKey] as? String {
                errorInfo += "\nRecovery Suggestion: \(localizedRecoverySuggestion)"
            }
            
            errorInfo += "\nLocalized Description: \(localizedDescription)"
            
            return errorInfo
        }
    }
}

// MARK: - LoggableWithContext

public protocol LoggableWithContext: Loggable {
    var context: String { get }
}

public extension Error where Self: LoggableWithContext {
    /// Side-effects the error logging and returning the error unchanged
    /// - Parameter tags: Tags needed to filter the error if needed
    /// - Returns: returns the error without changes
    func whileLogging(
        _ tags: [LogTag] = [],
        _ metadata: [String: String] = [:],
        file: String = #file,
        function: String = #function
    ) -> Self {
        log(tags, metadata.with { $0["Context"] = context })
        return self
    }
    
    /// Side-effects the error logging
    /// - Parameter tags: Tags needed to filter the error if needed
    func log(
        _ tags: [LogTag] = [],
        
        _ metadata: [String: String] = [:],
        file: String = #file,
        function: String = #function
    ) {
        Log.error(
            debugDescription,
            tags: tags,
            file: file,
            function: function,
            metadata: metadata.with { $0["Context"] = context }
        )
    }
}

// MARK: - Updateable

public protocol Updateable { }

public extension Updateable where Self: Any {
    /// Makes it available to set properties with closures just after initializing and copying the value types.
    ///
    ///     let frame = CGRect().with {
    ///       $0.origin.x = 10
    ///       $0.size.width = 100
    ///     }
    @inlinable
    func with(_ block: (inout Self) throws -> Void) rethrows -> Self {
        var copy = self
        try block(&copy)
        return copy
    }
    
    /// Makes it available to execute something with closures.
    ///
    ///     UserDefaults.standard.do {
    ///       $0.set("devxoul", forKey: "username")
    ///       $0.set("devxoul@gmail.com", forKey: "email")
    ///       $0.synchronize()
    ///     }
    @inlinable
    func `do`(_ block: (Self) throws -> Void) rethrows {
        try block(self)
    }
}

public extension Updateable where Self: AnyObject {
    /// Makes it available to set properties with closures just after initializing.
    ///
    ///     let label = UILabel().then {
    ///       $0.textAlignment = .center
    ///       $0.textColor = UIColor.black
    ///       $0.text = "Hello, World!"
    ///     }
    @inlinable
    func then(_ block: (Self) throws -> Void) rethrows -> Self {
        try block(self)
        return self
    }
}

// MARK: - NSObject + Updateable

extension NSObject: Updateable { }

// MARK: - Array + Updateable

extension Array: Updateable { }

// MARK: - Dictionary + Updateable

extension Dictionary: Updateable { }

// MARK: - Set + Updateable

extension Set: Updateable { }

// MARK: - JSONDecoder + Updateable

extension JSONDecoder: Updateable { }

// MARK: - JSONEncoder + Updateable

extension JSONEncoder: Updateable { }
