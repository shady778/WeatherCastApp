//
//  WeatherModel.swift
//  WeatherCastApp
//
//  Created by shady ramadan on 22/06/2026.
//

import Foundation

struct WeatherCondition: Hashable {
    let label: String
    let sfSymbol: String
}

struct WeatherMetric: Identifiable {
    let id = UUID()
    let title: String
    let value: String
    let unit: String
    let sfSymbol: String
}

struct DailyForecast: Identifiable {
    let id = UUID()
    let dayLabel: String
    let condition: WeatherCondition
    let low: Double
    let high: Double
}

struct HourlyWeather: Identifiable {
    let id = UUID()
    let label: String
    let condition: WeatherCondition
    let temperature: Int
}

struct CityWeather: Identifiable, Equatable {
    let id = UUID()
    let city: String
    let temperature: Int
    let condition: WeatherCondition
    let high: Int
    let low: Int
    let formattedLocalTime: String
    let localHour: Int 
 
    static func == (lhs: CityWeather, rhs: CityWeather) -> Bool {
        lhs.city == rhs.city
    }
}
