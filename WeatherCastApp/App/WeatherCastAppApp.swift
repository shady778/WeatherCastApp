//
//  WeatherCastAppApp.swift
//  WeatherCastApp
//
//  Created by shady ramadan on 15/06/2026.
//

import SwiftUI

@main
struct WeatherCastAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            SplashView()
                .modelContainer(for:SavedCity.self)
        }
    }
}
