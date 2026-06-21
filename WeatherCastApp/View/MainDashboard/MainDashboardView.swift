//
//  MainDashboardView.swift
//  WeatherCastApp
//
//  Created by shady ramadan on 15/06/2026.
//

import SwiftUI



struct MainDashboardView: View {
    @State private var currentHour: Int = Calendar.current.component(.hour, from: Date())

    var metrics: [WeatherMetric] {
        [
            WeatherMetric(title: "VISIBILITY", value: "10", unit: "km", sfSymbol: "eye.fill"),
            WeatherMetric(title: "HUMIDITY", value: "36", unit: "%", sfSymbol: "humidity.fill"),
            WeatherMetric(title: "FEELS LIKE", value: "16", unit: "°", sfSymbol: "thermometer.medium"),
            WeatherMetric(title: "PRESSURE", value: "1,021", unit: "hPa", sfSymbol: "gauge.with.dots.needle.50percent")
        ]
    }

    var body: some View {
        ZStack {
            AppTheme.background(hour: currentHour)
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {

                            VStack(spacing: 6) {
                        Text("Cairo")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundStyle(AppTheme.primaryText(hour: currentHour))

                        Text("21°")
                            .font(.system(size: 90, weight: .thin, design: .rounded))
                            .foregroundStyle(AppTheme.primaryText(hour: currentHour))

                        Text("Partly Cloudy")
                            .font(.system(size: 17, weight: .medium, design: .rounded))
                            .foregroundStyle(AppTheme.secondaryText(hour: currentHour))

                        Text("H:16°   L:6°")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundStyle(AppTheme.tertiaryText(hour: currentHour))

                        WeatherIcon(sfSymbol: "cloud.sun.fill", size: 64, hour: currentHour)
                            .padding(.top, 8)
                    }
                    .padding(.top, 30)
                    VStack(alignment: .leading, spacing: 16) {
                        Text("3-DAY FORECAST")
                            .font(.system(size: 12, weight: .semibold, design: .rounded))
                            .tracking(1.5)
                            .foregroundStyle(AppTheme.secondaryText(hour: currentHour))

                        VStack(spacing: 12) {
                            forecastRow(day: "Today", icon: "cloud.sun.fill", low: "7.8°", high: "15.5°")
                            Divider().overlay(AppTheme.glassBorder(hour: currentHour))
                            forecastRow(day: "Wed", icon: "cloud.rain.fill", low: "6.4°", high: "16.1°")
                            Divider().overlay(AppTheme.glassBorder(hour: currentHour))
                            forecastRow(day: "Thu", icon: "sun.max.fill", low: "8.7°", high: "17.8°")
                        }
                    }
                    .padding(18)
                    .glassCard(hour: currentHour)
                    .padding(.horizontal)
                     LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                        ForEach(metrics) { metric in
                            MetricCard(metric: metric, hour: currentHour)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                }
            }
        }
    }

      func forecastRow(day: String, icon: String, low: String, high: String) -> some View {
        HStack {
            Text(day)
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundStyle(AppTheme.primaryText(hour: currentHour))
                .frame(width: 60, alignment: .leading)

            Spacer()

            WeatherIcon(sfSymbol: icon, size: 20, hour: currentHour)

            Spacer()

            HStack(spacing: 6) {
                Text(low)
                    .foregroundStyle(AppTheme.secondaryText(hour: currentHour))
                Text(high)
                    .foregroundStyle(AppTheme.primaryText(hour: currentHour))
            }
            .font(.system(size: 15, weight: .medium, design: .rounded))
            .frame(width: 90, alignment: .trailing)
        }
    }
}

extension MainDashboardView {
    init(currentHour: Int) {
        _currentHour = State(initialValue: currentHour)
    }
}

#Preview("Morning") {
    MainDashboardView(currentHour: 12)
}

#Preview("Night") {
    MainDashboardView(currentHour: 21)
}
