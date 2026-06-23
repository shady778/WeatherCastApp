//
//  WeatherSearchBar.swift
//  WeatherCastApp
//
//  Created by shady ramadan on 21/06/2026.
//

import Foundation
import SwiftUI
 
struct WeatherSearchBar: View {
    @Binding var text: String
    let hour: Int
    let onSearch: (String) -> Void
    let onCancel: () -> Void
 
    var body: some View {
        HStack(spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(AppTheme.secondaryText(hour: hour))
 
                TextField("Search city…", text: $text)
                    .font(.system(size: 16, design: .rounded))
                    .foregroundStyle(AppTheme.primaryText(hour: hour))
                    .tint(AppTheme.accent(hour: hour))
                    .onChange(of: text) { _, newVal in onSearch(newVal) }
 
                if !text.isEmpty {
                    Button {
                        text = ""
                        onSearch("")
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 15))
                            .foregroundStyle(AppTheme.tertiaryText(hour: hour))
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .glassCard(hour: hour, cornerRadius: 14)
 
            Button("Cancel", action: onCancel)
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundStyle(AppTheme.accent(hour: hour))
        }
    }
}
