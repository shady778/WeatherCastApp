//
//  WeatherViewModel.swift
//  WeatherCastApp
//
//  Created by shady ramadan on 23/06/2026.
//

import Foundation
import SwiftUI

@MainActor
class WeatherViewModel: ObservableObject {
    @Published var cityWeather: CityWeather? = nil
    @Published var dailyForecasts: [DailyForecast] = []
    @Published var hourlyForecasts: [HourlyWeather] = []
    @Published var metrics: [WeatherMetric] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var savedCities: [CityWeather] = []
    
    private let repository: WeatherRepositoryProtocol
    
    init(repository: WeatherRepositoryProtocol = WeatherRepository()) {
        self.repository = repository
    }
    
    func fetchWeather(for city: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await repository.getWeather(for: city)
            
            self.cityWeather = result.cityWeather
            self.dailyForecasts = result.dailyForecast
            self.hourlyForecasts = result.hourlyForecast
            self.metrics = result.metrics
            
            let freshCity = result.cityWeather
            if !savedCities.contains(where: { $0.city.lowercased() == freshCity.city.lowercased() }) {
                savedCities.append(freshCity)
            }
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
