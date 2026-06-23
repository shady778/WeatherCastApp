//
//  HourlyForecastView.swift
//  WeatherCastApp
//
//  Created by shady ramadan on 21/06/2026.
//

import SwiftUI
 
struct HourlyForecastView: View {
    let city: CityWeather
    let selectedDay: DailyForecast
    let hourly: [HourlyWeather]
    let hour: Int
 
    @Environment(\.dismiss) private var dismiss
 
    var body: some View {
        ZStack {
            AppTheme.background(hour: hour)
                .ignoresSafeArea()
 
            VStack(spacing: 0) {
 
                              HStack {
                    Button {
                        dismiss()
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 17, weight: .semibold))
                            Text("Back")
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                        }
                        .foregroundStyle(AppTheme.primaryText(hour: hour))
                    }
 
                    Spacer()
 
                    VStack(spacing: 2) {
                        Text(city.city)
                            .font(.system(size: 17, weight: .bold, design: .rounded))
                            .foregroundStyle(AppTheme.primaryText(hour: hour))
                        Text(selectedDay.dayLabel == "Today" ? "Today's Hourly" : "\(selectedDay.dayLabel) Hourly")
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .foregroundStyle(AppTheme.secondaryText(hour: hour))
                    }
 
                    Spacer()
 
                    HStack(spacing: 6) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .opacity(0)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
 
                Divider()
                    .overlay(AppTheme.glassBorder(hour: hour))
                    .padding(.horizontal, 20)
 
                           HStack(spacing: 16) {
                    WeatherIcon(sfSymbol: selectedDay.condition.sfSymbol, size: 40, hour: hour)
 
                    VStack(alignment: .leading, spacing: 4) {
                        Text(selectedDay.dayLabel)
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundStyle(AppTheme.primaryText(hour: hour))
                        Text(selectedDay.condition.label)
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundStyle(AppTheme.secondaryText(hour: hour))
                    }
 
                    Spacer()
 
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("H:\(Int(selectedDay.high))°")
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundStyle(AppTheme.primaryText(hour: hour))
                        Text("L:\(Int(selectedDay.low))°")
                            .font(.system(size: 15, weight: .medium, design: .rounded))
                            .foregroundStyle(AppTheme.secondaryText(hour: hour))
                    }
                }
                .padding(20)
                .glassCard(hour: hour, cornerRadius: 16)
                .padding(.horizontal, 20)
                .padding(.top, 16)
 
                        ScrollView(showsIndicators: false) {
                    VStack(spacing: 10) {
                        ForEach(Array(hourly.enumerated()), id: \.element.id) { idx, item in
                            HourlyRow(hourly: item, hour: hour, isFirst: idx == 0)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 20)
                }
            }
        }
        .navigationBarHidden(true)
    }
}
 
//#Preview("Hourly — Morning") {
//    HourlyForecastView(
//        city: MockWeather.cairo,
//        selectedDay: MockWeather.threeDayForecast[0],
//        hourly: MockWeather.todayHourly,
//        hour: 12
//    )
//}
// 
//#Preview("Hourly — Night") {
//    HourlyForecastView(
//        city: MockWeather.cairo,
//        selectedDay: MockWeather.threeDayForecast[1],
//        hourly: MockWeather.todayHourly,
//        hour: 21
//    )
//}
