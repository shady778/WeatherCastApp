//
//  MockModel.swift
//  WeatherCastApp
//
//  Created by shady ramadan on 15/06/2026.
//

import Foundation
import SwiftUI


struct WeatherCondition: Identifiable, Hashable {
    let id = UUID()
    let label: String
    let sfSymbol: String
}

struct HourlyWeather: Identifiable {
    let id = UUID()
    let label: String
    let condition: WeatherCondition
    let temperature: Int
}

struct DailyForecast: Identifiable {
    let id = UUID()
    let dayLabel: String
    let condition: WeatherCondition
    let low: Double
    let high: Double
}

struct WeatherMetric: Identifiable {
    let id = UUID()
    let title: String
    let value: String
    let unit: String
    let sfSymbol: String
}

struct CityWeather: Identifiable, Equatable {
    let id = UUID()
    let city: String
    let country: String
    let temperature: Int
    let condition: WeatherCondition
    let high: Int
    let low: Int
    let hourlyForecast: [HourlyWeather]
    let dailyForecast: [DailyForecast]
    let metrics: [WeatherMetric]

    static func == (lhs: CityWeather, rhs: CityWeather) -> Bool {
        lhs.id == rhs.id
    }
}


enum MockWeatherFactory {
   static let partlyCloudy  = WeatherCondition(label: "Partly Cloudy",  sfSymbol: "cloud.sun.fill")
    static let sunny         = WeatherCondition(label: "Sunny",          sfSymbol: "sun.max.fill")
    static let rainy         = WeatherCondition(label: "Rainy",          sfSymbol: "cloud.rain.fill")
    static let stormy        = WeatherCondition(label: "Stormy",         sfSymbol: "cloud.bolt.rain.fill")
    static let cloudy        = WeatherCondition(label: "Cloudy",         sfSymbol: "cloud.fill")
    static let snowy         = WeatherCondition(label: "Snowy",          sfSymbol: "cloud.snow.fill")
    static let windy         = WeatherCondition(label: "Windy",          sfSymbol: "wind")
    static let foggy         = WeatherCondition(label: "Foggy",          sfSymbol: "cloud.fog.fill")
    static let clearNight    = WeatherCondition(label: "Clear",          sfSymbol: "moon.stars.fill")

      static func cairoWeather() -> CityWeather {
        CityWeather(
            city: "Cairo",
            country: "EG",
            temperature: 21,
            condition: partlyCloudy,
            high: 16,
            low: 6,
            hourlyForecast: [
                HourlyWeather(label: "Now",  condition: partlyCloudy, temperature: 15),
                HourlyWeather(label: "3PM",  condition: partlyCloudy, temperature: 15),
                HourlyWeather(label: "4PM",  condition: cloudy,       temperature: 14),
                HourlyWeather(label: "5PM",  condition: cloudy,       temperature: 13),
                HourlyWeather(label: "6PM",  condition: clearNight,   temperature: 12),
                HourlyWeather(label: "7PM",  condition: clearNight,   temperature: 11),
                HourlyWeather(label: "8PM",  condition: clearNight,   temperature: 10),
                HourlyWeather(label: "9PM",  condition: clearNight,   temperature: 9),
            ],
            dailyForecast: [
                DailyForecast(dayLabel: "Today",    condition: partlyCloudy, low: 7.8,  high: 15.5),
                DailyForecast(dayLabel: "Wed",      condition: cloudy,       low: 6.4,  high: 16.1),
                DailyForecast(dayLabel: "Thu",      condition: sunny,        low: 8.7,  high: 17.8),
            ],
            metrics: cairoMetrics()
        )
    }

    static func cairoMetrics() -> [WeatherMetric] { [
        WeatherMetric(title: "VISIBILITY",  value: "10",    unit: "km",  sfSymbol: "eye.fill"),
        WeatherMetric(title: "HUMIDITY",    value: "36",    unit: "%",   sfSymbol: "humidity.fill"),
        WeatherMetric(title: "FEELS LIKE",  value: "16",    unit: "°",   sfSymbol: "thermometer.medium"),
        WeatherMetric(title: "PRESSURE",    value: "1,021", unit: "hPa", sfSymbol: "gauge.with.dots.needle.33percent"),
    ] }

      static func londonWeather() -> CityWeather {
        CityWeather(
            city: "London",
            country: "GB",
            temperature: 11,
            condition: rainy,
            high: 13,
            low: 7,
            hourlyForecast: [
                HourlyWeather(label: "Now", condition: rainy,   temperature: 11),
                HourlyWeather(label: "3PM", condition: rainy,   temperature: 10),
                HourlyWeather(label: "4PM", condition: cloudy,  temperature: 9),
                HourlyWeather(label: "5PM", condition: cloudy,  temperature: 8),
                HourlyWeather(label: "6PM", condition: stormy,  temperature: 7),
            ],
            dailyForecast: [
                DailyForecast(dayLabel: "Today", condition: rainy,   low: 7.0, high: 13.0),
                DailyForecast(dayLabel: "Wed",   condition: cloudy,  low: 6.0, high: 12.5),
                DailyForecast(dayLabel: "Thu",   condition: stormy,  low: 5.0, high: 11.0),
            ],
            metrics: [
                WeatherMetric(title: "VISIBILITY",  value: "5",     unit: "km",  sfSymbol: "eye.fill"),
                WeatherMetric(title: "HUMIDITY",    value: "82",    unit: "%",   sfSymbol: "humidity.fill"),
                WeatherMetric(title: "FEELS LIKE",  value: "8",     unit: "°",   sfSymbol: "thermometer.medium"),
                WeatherMetric(title: "PRESSURE",    value: "998",   unit: "hPa", sfSymbol: "gauge.with.dots.needle.33percent"),
            ]
        )
    }

    static func tokyoWeather() -> CityWeather {
        CityWeather(
            city: "Tokyo",
            country: "JP",
            temperature: 18,
            condition: sunny,
            high: 22,
            low: 12,
            hourlyForecast: [
                HourlyWeather(label: "Now", condition: sunny,        temperature: 18),
                HourlyWeather(label: "3PM", condition: sunny,        temperature: 20),
                HourlyWeather(label: "4PM", condition: partlyCloudy, temperature: 19),
                HourlyWeather(label: "5PM", condition: partlyCloudy, temperature: 17),
                HourlyWeather(label: "6PM", condition: clearNight,   temperature: 15),
            ],
            dailyForecast: [
                DailyForecast(dayLabel: "Today", condition: sunny,        low: 12.0, high: 22.0),
                DailyForecast(dayLabel: "Wed",   condition: partlyCloudy, low: 13.0, high: 21.0),
                DailyForecast(dayLabel: "Thu",   condition: rainy,        low: 11.0, high: 19.0),
            ],
            metrics: [
                WeatherMetric(title: "VISIBILITY",  value: "15",    unit: "km",  sfSymbol: "eye.fill"),
                WeatherMetric(title: "HUMIDITY",    value: "55",    unit: "%",   sfSymbol: "humidity.fill"),
                WeatherMetric(title: "FEELS LIKE",  value: "17",    unit: "°",   sfSymbol: "thermometer.medium"),
                WeatherMetric(title: "PRESSURE",    value: "1,013", unit: "hPa", sfSymbol: "gauge.with.dots.needle.33percent"),
            ]
        )
    }

    static func newYorkWeather() -> CityWeather {
        CityWeather(
            city: "New York",
            country: "US",
            temperature: 8,
            condition: windy,
            high: 10,
            low: 3,
            hourlyForecast: [
                HourlyWeather(label: "Now", condition: windy,   temperature: 8),
                HourlyWeather(label: "3PM", condition: cloudy,  temperature: 7),
                HourlyWeather(label: "4PM", condition: cloudy,  temperature: 6),
                HourlyWeather(label: "5PM", condition: snowy,   temperature: 4),
                HourlyWeather(label: "6PM", condition: snowy,   temperature: 3),
            ],
            dailyForecast: [
                DailyForecast(dayLabel: "Today", condition: windy,   low: 3.0, high: 10.0),
                DailyForecast(dayLabel: "Wed",   condition: snowy,   low: 1.0, high: 7.0),
                DailyForecast(dayLabel: "Thu",   condition: cloudy,  low: 2.0, high: 9.0),
            ],
            metrics: [
                WeatherMetric(title: "VISIBILITY",  value: "8",     unit: "km",  sfSymbol: "eye.fill"),
                WeatherMetric(title: "HUMIDITY",    value: "61",    unit: "%",   sfSymbol: "humidity.fill"),
                WeatherMetric(title: "FEELS LIKE",  value: "3",     unit: "°",   sfSymbol: "thermometer.medium"),
                WeatherMetric(title: "PRESSURE",    value: "1,008", unit: "hPa", sfSymbol: "gauge.with.dots.needle.33percent"),
            ]
        )
    }

    static func allCities() -> [CityWeather] {
        [cairoWeather(), londonWeather(), tokyoWeather(), newYorkWeather()]
    }
}
