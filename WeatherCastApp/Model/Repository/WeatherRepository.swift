//
//  WeatherRepository.swift
//  WeatherCastApp
//
//  Created by shady ramadan on 23/06/2026.
//

import Foundation
class WeatherRepository: WeatherRepositoryProtocol {
    private let remoteService: WeatherServiceProtocol
    
    init(remoteService: WeatherServiceProtocol = WeatherService()) {
        self.remoteService = remoteService
    }
    
    func getWeather(for city: String) async throws -> WeatherResult {
        return try await remoteService.fetchWeather(for: city)
    }
    
    func getWeather(lat: Double, lon: Double) async throws -> WeatherResult {
        return try await remoteService.fetchWeather(lat: lat, lon: lon)
    }
    
    func searchCities(query: String) async throws -> [SearchResult] {
        return try await remoteService.searchCities(query: query)
    }
}
