//
//  SavedCity.swift
//  WeatherCastApp
//
//  Created by shady ramadan on 23/06/2026.
//

import Foundation
import SwiftData

@Model
final class SavedCity {
    @Attribute(.unique) var city: String
    var temperature: Int
    var conditionLabel: String
    var conditionSymbol: String
    var high: Int
    var low: Int
    var formattedLocalTime: String
    var localHour: Int
    
    init(city: String, temperature: Int, conditionLabel: String, conditionSymbol: String, high: Int, low: Int, formattedLocalTime: String, localHour: Int) {
        self.city = city
        self.temperature = temperature
        self.conditionLabel = conditionLabel
        self.conditionSymbol = conditionSymbol
        self.high = high
        self.low = low
        self.formattedLocalTime = formattedLocalTime
        self.localHour = localHour
    }
    
    var toCityWeather: CityWeather {
        CityWeather(
            city: self.city,
            temperature: self.temperature,
            condition: WeatherCondition(label: self.conditionLabel, sfSymbol: self.conditionSymbol),
            high: self.high,
            low: self.low,
            formattedLocalTime: self.formattedLocalTime,
            localHour: self.localHour
        )
    }
}
