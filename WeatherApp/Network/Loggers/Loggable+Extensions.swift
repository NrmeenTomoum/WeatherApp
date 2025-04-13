//
//  Loggable+Extensions.swift
//  Weather
//
//  Created by Nermeen Tomoum on 12/04/2025.
//

import Foundation
import UserNotifications

// MARK: - Dictionary + Loggable

extension Dictionary: Loggable {
    public var debugDescription: String {
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(data: data, encoding: .utf8) ?? "No values found"
        } catch {
            return "Couldn't map this dictionary"
        }
    }
}

// MARK: - URLRequest + Loggable

extension URLRequest: Loggable {
    public var debugDescription: String {
        """
        URL: \(url?.absoluteString ?? .noneFound)
        For more info, Check Pulse or FLEX
        """
    }
}

// MARK: - HTTPURLResponse + Loggable

extension HTTPURLResponse: Loggable {
    override public var debugDescription: String {
        """
        URL: \(url?.absoluteString ?? .noneFound)
        Status Code: \(statusCode)
        For more info, Check Pulse or FLEX
        """
    }
}

// MARK: - Data + Loggable

extension Data: Loggable {
    public var debugDescription: String {
        String(data: self, encoding: .utf8) ?? "🤷‍♂️ Couldn't Parse the data"
    }
    
    /// Wrapper around `debugDescription` as Swift.Data already has debugDescription which can't be overriden from an extension
    public var loggableDescription: String {
        debugDescription
    }
}

// MARK: - UNNotificationRequest + Loggable

extension UNNotificationRequest: Loggable {
    public var metadata: [String: String] {
        ["Identifier": identifier]
    }
}

public extension UNNotificationContent {
    var metadata: [String: String] {
        [
            "Title" : title,
            "Subtitle" : subtitle,
            "Body" : body,
            "Has Attachments?" : (!attachments.isEmpty).description
        ]
    }
}

// MARK: - UNNotificationTrigger + Loggable

extension UNNotificationTrigger: Loggable {
    public var metadata: [String: String] {
        [
            "Will be rescheduled by the System?": repeats.description
        ]
    }
}

private extension String {
    static let noneFound = "🤷‍♂️ None Found"
}
