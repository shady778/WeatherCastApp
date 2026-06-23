//
//  WeatherRepositoryProtocol.swift
//  WeatherCastApp
//
//  Created by shady ramadan on 23/06/2026.
//

import Foundation
protocol WeatherRepositoryProtocol {
    func getWeather(for city: String) async throws -> WeatherResult
    func getWeather(lat: Double, lon: Double) async throws -> WeatherResult
    func searchCities(query: String) async throws -> [SearchResult]
}
