//
//  SystemLogger.swift
//  Weather
//
//  Created by Nermeen Tomoum on 12/04/2025.
//

import OSLog

// MARK: - SystemLogger

// swiftlint:disable no_direct_standard_out_logs
public final class SystemLogger: Logger {
    public static let main: SystemLogger = .init()
    private init() { }
    
    private let logger = os.Logger(subsystem: "Weather", category: "Logger")
    
    public func info(
        message: String,
        tags: [LogTag],
        file: String = "",
        function: String = "",
        metadata: [String: String] = [:]
    ) {
        let formattedMessage = formatMessage(message: message, tags: tags, file: file, function: function, metadata: metadata)
        logger.info("\(formattedMessage)")
    }
    
    public func warn(
        message: String,
        tags: [LogTag],
        file: String = "",
        function: String = "",
        metadata: [String: String] = [:]
    ) {
        let formattedMessage = formatMessage(message: message, tags: tags, file: file, function: function, metadata: metadata)
        logger.notice("\(formattedMessage)")
    }
    
    public func error(
        message: String,
        tags: [LogTag],
        file: String = "",
        function: String = "",
        metadata: [String: String] = [:]
    ) {
        let formattedMessage = formatMessage(message: message, tags: tags, file: file, function: function, metadata: metadata)
        logger.error("\(formattedMessage)")
    }
}

private extension SystemLogger {
    func formatMessage(
        message: String,
        tags: [LogTag],
        file: String = "",
        function: String = "",
        metadata: [String: String] = [:]
    ) -> String {
        var message = message
            .withPrefix(
                "\(tags.map { $0.rawValue }.joined(separator: " ")) "
            )
        
        if !metadata.isEmpty {
            message = message
                .withSuffix("\n")
                .withSuffix("----Metadata-----")
                .withSuffix("\n")
                .withSuffix(metadata.debugDescription)
                .withSuffix("\n")
        }
        
        return message
    }
}

public extension String {
    func tagWith(_ tag: LogTag?) -> String {
        guard let tag else { return self }
        return withPrefix("\(tag.rawValue) ")
    }
    
    func tagWith(_ tag: LogTag) -> String {
        withPrefix("\(tag.rawValue) ")
    }
    
    func tagWith(_ tags: [LogTag]) -> String {
        tags.map { "[\($0.rawValue)]" }.joined(separator: " ").withPrefix(" \(self)")
    }
    
    func withPrefix(_ prefix: String) -> String {
        "\(prefix)\(self)"
    }
    
    func withSuffix(_ suffix: String) -> String {
        "\(self)\(suffix)"
    }
    
    mutating func prefix(with prefix: String) {
        self = "\(prefix)\(self)"
    }
    
    mutating func suffix(with suffix: String) {
        self = "\(self)\(suffix)"
    }
}

public extension SystemLogger {
    func networkTaskCreated(url: String?, _: URLSessionTask) {
        info(message: "Task Created {\(url ?? "")}", tags: [.network])
    }
    
    func networkDidReceive(data: Data, for task: URLSessionDataTask, in _: URLSession) {
        info(message: "Data Received {\(url(from: task))}, \n \(data.debugDescription)", tags: [.network])
    }
    
    func networkTaskFailed(withError error: Error?, for task: URLSessionTask, in _: URLSession) {
        if let error {
            info(message: "Task Failed with error: {\(url(from: task))}, \n \(String(describing: error))", tags: [.network])
        }
    }
    
    func networkDecodingFailed(for task: URLSessionTask, with decodingError: DecodingError?, for type: Decodable.Type) {
        if let decodingError {
            info(
                message: "Decoding Failed for task: {\(url(from: task))}, \n expected type: {\(type)} \n with error: \(String(describing: decodingError))",
                tags: [.network, .parsing]
            )
        }
    }
    
    private func url(from task: URLSessionTask) -> String {
        task.response?.url?.absoluteString ?? ""
    }
}
