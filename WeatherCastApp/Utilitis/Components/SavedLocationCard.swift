//
//  SavedLocationCard.swift
//  WeatherCastApp
//
//  Created by shady ramadan on 21/06/2026.
//

import Foundation
import SwiftUI
 
struct SavedLocationCard: View {
    let city: CityWeather
    let isCurrent: Bool
    let hour: Int
    let onSelect: () -> Void
 
    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 14) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Text(city.city)
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundStyle(AppTheme.primaryText(hour: hour))
                        if isCurrent {
                            Text("CURRENT")
                                .font(.system(size: 9, weight: .bold, design: .rounded))
                                .tracking(1)
                                .foregroundStyle(AppTheme.accent(hour: hour))
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(AppTheme.accent(hour: hour).opacity(0.15))
                                .clipShape(Capsule())
                        }
                    }
                    Text(city.condition.label)
                        .font(.system(size: 13, design: .rounded))
                        .foregroundStyle(AppTheme.secondaryText(hour: hour))
                    Text("H:\(city.high)°  L:\(city.low)°")
                        .font(.system(size: 12, design: .rounded))
                        .foregroundStyle(AppTheme.tertiaryText(hour: hour))
                }
 
                Spacer()
 
                VStack(alignment: .trailing, spacing: 6) {
                    WeatherIcon(sfSymbol: city.condition.sfSymbol, size: 28, hour: hour)
                    Text("\(city.temperature)°")
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .foregroundStyle(AppTheme.primaryText(hour: hour))
                }
            }
            .padding(18)
            .glassCard(hour: hour, cornerRadius: 18)
            .overlay(
                isCurrent
                    ? RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(AppTheme.accent(hour: hour), lineWidth: 1.5)
                    : nil
            )
        }
        .buttonStyle(.plain)
    }
}
 
