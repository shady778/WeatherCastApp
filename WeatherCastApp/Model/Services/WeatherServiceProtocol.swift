//
//  WeatherServiceProtocol.swift
//  WeatherCastApp
//
//  Created by shady ramadan on 22/06/2026.
//

import Foundation
import Foundation

struct WeatherResult {
    let cityWeather: CityWeather
    let dailyForecast: [DailyForecast]
    let hourlyForecast: [HourlyWeather]
    let metrics: [WeatherMetric]
}

protocol WeatherServiceProtocol {
    func fetchWeather(for city: String) async throws -> WeatherResult
    func fetchWeather(lat: Double, lon: Double) async throws -> WeatherResult
    func searchCities(query: String) async throws -> [SearchResult]
}
