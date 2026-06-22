//
//  HourlyRow.swift
//  WeatherCastApp
//
//  Created by shady ramadan on 21/06/2026.
//

import Foundation
import SwiftUI
 
struct HourlyRow: View {
    let hourly: HourlyWeather
    let hour: Int
    let isFirst: Bool
 
    var body: some View {
        HStack(spacing: 16) {
            Text(hourly.label)
                .font(.system(size: 16, weight: isFirst ? .bold : .medium, design: .rounded))
                .foregroundStyle(isFirst ? AppTheme.accent(hour: hour) : AppTheme.primaryText(hour: hour))
                .frame(width: 48, alignment: .leading)
 
            WeatherIcon(sfSymbol: hourly.condition.sfSymbol, size: 26, hour: hour)
 
            Text(hourly.condition.label)
                .font(.system(size: 14, weight: .regular, design: .rounded))
                .foregroundStyle(AppTheme.secondaryText(hour: hour))
                .frame(maxWidth: .infinity, alignment: .leading)
 
            Text("\(hourly.temperature)°")
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundStyle(AppTheme.primaryText(hour: hour))
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .glassCard(hour: hour, cornerRadius: 16)
    }
}
 
