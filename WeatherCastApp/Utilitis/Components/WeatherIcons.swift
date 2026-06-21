//
//  WeatherIcons.swift
//  WeatherCastApp
//
//  Created by shady ramadan on 15/06/2026.
//

import Foundation
import SwiftUI

struct WeatherIcon: View {
    let sfSymbol: String
    let size: CGFloat
    let hour: Int

    var body: some View {
        Image(systemName: sfSymbol)
            .symbolRenderingMode(.multicolor)
            .font(.system(size: size, weight: .medium))
            .shadow(color: AppTheme.accent(hour: hour).opacity(0.4), radius: 8, x: 0, y: 4)
    }
}
