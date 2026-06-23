//
//  WeatherViewModel.swift
//  WeatherCastApp
//
//  Created by shady ramadan on 23/06/2026.
//

import Foundation
import SwiftUI
import SwiftData

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
    private var modelContext: ModelContext?
    
    init(repository: WeatherRepositoryProtocol = WeatherRepository()) {
        self.repository = repository
    }
    
    func setupContext(_ context: ModelContext) {
        self.modelContext = context
        fetchSavedCities()
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
                updateSavedCityIfNeeded(freshCity)
            
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    var isCurrentCitySaved: Bool {
        guard let currentCity = cityWeather else { return false }
        return savedCities.contains(where: { $0.city.lowercased() == currentCity.city.lowercased() })
    }
    
    func toggleSaveCurrentCity() {
        guard let currentCity = cityWeather, let context = modelContext else { return }
        
        if isCurrentCitySaved {
            deleteCity(currentCity)
        } else {
            let newSaved = SavedCity(
                city: currentCity.city,
                temperature: currentCity.temperature,
                conditionLabel: currentCity.condition.label,
                conditionSymbol: currentCity.condition.sfSymbol,
                high: currentCity.high,
                low: currentCity.low,
                formattedLocalTime: currentCity.formattedLocalTime,
                localHour: currentCity.localHour
            )
            context.insert(newSaved)
            try? context.save()
            fetchSavedCities()
        }
    }
    
    func deleteCity(_ city: CityWeather) {
        guard let context = modelContext else { return }
        let cityName = city.city.lowercased()
        let descriptor = FetchDescriptor<SavedCity>()
        
        if let allSaved = try? context.fetch(descriptor) {
            if let target = allSaved.first(where: { $0.city.lowercased() == cityName }) {
                context.delete(target)
                try? context.save()
                fetchSavedCities()
            }
        }
    }
    
    func fetchSavedCities() {
        guard let context = modelContext else { return }
        let descriptor = FetchDescriptor<SavedCity>()
        
        if let fetchedModels = try? context.fetch(descriptor) {
            self.savedCities = fetchedModels.map { $0.toCityWeather }
        }
    }
    
    private func updateSavedCityIfNeeded(_ city: CityWeather) {
        guard let context = modelContext else { return }
        let cityName = city.city.lowercased()
        let descriptor = FetchDescriptor<SavedCity>()
        
        if let allSaved = try? context.fetch(descriptor),
           let target = allSaved.first(where: { $0.city.lowercased() == cityName }) {
            target.temperature = city.temperature
            target.conditionLabel = city.condition.label
            target.conditionSymbol = city.condition.sfSymbol
            target.high = city.high
            target.low = city.low
            target.formattedLocalTime = city.formattedLocalTime
            target.localHour = city.localHour
            try? context.save()
            fetchSavedCities()
        }
    }
}
