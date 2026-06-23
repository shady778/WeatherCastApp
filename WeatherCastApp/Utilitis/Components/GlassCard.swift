//
//  GlassCard.swift
//  WeatherCastApp
//
//  Created by shady ramadan on 15/06/2026.
//

import Foundation
import SwiftUI

struct GlassCard: ViewModifier {
    let hour: Int
    var cornerRadius: CGFloat = 20
   private var isMorning: Bool {
        hour >= 6 && hour < 18
    }

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(AppTheme.glassBackground(hour: hour))
                    .background(
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .fill(.ultraThinMaterial)
                    )
                    .environment(\.colorScheme, isMorning ? .light : .dark)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .stroke(AppTheme.glassBorder(hour: hour), lineWidth: 1)
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }
}

extension View {
    func glassCard(hour: Int, cornerRadius: CGFloat = 20) -> some View {
        modifier(GlassCard(hour: hour, cornerRadius: cornerRadius))
    }
}
