//
//  ForecastRow.swift
//  WeatherCastApp
//
//  Created by shady ramadan on 21/06/2026.
//

import Foundation
import SwiftUI
 
struct ForecastRow: View {
    let forecast: DailyForecast
    let hour: Int
    let onTap: () -> Void
 
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 0) {
                Text(forecast.dayLabel)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundStyle(AppTheme.primaryText(hour: hour))
                    .frame(width: 72, alignment: .leading)
 
                WeatherIcon(sfSymbol: forecast.condition.sfSymbol, size: 22, hour: hour)
 
                Spacer()
 
                Text(String(format: "%.1f°", forecast.low))
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundStyle(AppTheme.tertiaryText(hour: hour))
 
                Text("  —  ")
                    .font(.system(size: 13))
                    .foregroundStyle(AppTheme.tertiaryText(hour: hour))
 
                Text(String(format: "%.1f°", forecast.high))
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundStyle(AppTheme.primaryText(hour: hour))
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(.plain)
    }
}
