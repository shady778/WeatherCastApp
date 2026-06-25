//
//  AppTheme.swift
//  WeatherCastApp
//
//  Created by shady ramadan on 15/06/2026.
//

import Foundation
import SwiftUI

struct AppTheme {
    static func isMorning(hour: Int) -> Bool {
        hour >= 5 && hour < 18
    }
    static func primaryText(hour: Int) -> Color {
        isMorning(hour: hour) ? .black : .white
    }
    
    static func secondaryText(hour: Int) -> Color {
        isMorning(hour: hour) ? Color.black.opacity(0.60) : Color.white.opacity(0.72)
    }
    
    static func tertiaryText(hour: Int) -> Color {
        isMorning(hour: hour) ? Color.black.opacity(0.40) : Color.white.opacity(0.50)
    }
    
    static func glassBackground(hour: Int) -> Color {
        isMorning(hour: hour) ? Color.white.opacity(0.35) : Color.white.opacity(0.10)
    }
    
    static func glassBorder(hour: Int) -> Color {
        isMorning(hour: hour) ? Color.white.opacity(0.60) : Color.white.opacity(0.20)
    }
    static func accent(hour: Int) -> Color {
        isMorning(hour: hour)
        ? Color(red: 0.13, green: 0.53, blue: 0.90): Color(red: 0.42, green: 0.69, blue: 1.00)
    }
    
    
    static func backgroundGIFName(hour: Int) -> String {
        isMorning(hour: hour) ? "morning_sky" : "evening_sky"
    }
    
       @ViewBuilder
    static func background(hour: Int) -> some View {
           GIFBackgroundView(gifName: backgroundGIFName(hour: hour))
        }
    }

