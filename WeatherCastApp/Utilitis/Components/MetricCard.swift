//
//  MetricCard.swift
//  WeatherCastApp
//
//  Created by shady ramadan on 15/06/2026.
//

import Foundation
import SwiftUI

struct MetricCard: View {
    let metric: WeatherMetric
    let hour: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: metric.sfSymbol)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(AppTheme.accent(hour: hour))
                Text(metric.title)
                    .font(.system(size: 11, weight: .semibold, design: .rounded))
                    .tracking(1.2)
                    .foregroundStyle(AppTheme.secondaryText(hour: hour))
            }

            HStack(alignment: .lastTextBaseline, spacing: 2) {
                Text(metric.value)
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundStyle(AppTheme.primaryText(hour: hour))
                Text(metric.unit)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundStyle(AppTheme.secondaryText(hour: hour))
                    .padding(.bottom, 2)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .glassCard(hour: hour)
    }
}
