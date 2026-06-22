//
//  CityResultRow.swift
//  WeatherCastApp
//
//  Created by shady ramadan on 21/06/2026.
//

import Foundation
import SwiftUI
struct CityResultRow: View {
    let city: CityWeather
    let hour: Int
    let onSelect: () -> Void
 
    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 14) {
                WeatherIcon(sfSymbol: city.condition.sfSymbol, size: 28, hour: hour)
 
                VStack(alignment: .leading, spacing: 3) {
                    Text(city.city)
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .foregroundStyle(AppTheme.primaryText(hour: hour))
                    Text(city.condition.label)
                        .font(.system(size: 13, design: .rounded))
                        .foregroundStyle(AppTheme.secondaryText(hour: hour))
                }
 
                Spacer()
 
                Text("\(city.temperature)°")
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundStyle(AppTheme.primaryText(hour: hour))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .glassCard(hour: hour, cornerRadius: 16)
        }
        .buttonStyle(.plain)
    }
}
