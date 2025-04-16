//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Nermeen Tomoum on 12/04/2025.
//

import SwiftUI

@main
struct WeatherAppApp: App {
    var body: some Scene {
        WindowGroup {
            WeatherView(viewModel: .init())
        }
    }
}
