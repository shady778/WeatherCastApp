//
//  WeatherAPIResponse.swift
//  WeatherCastApp
//
//  Created by shady ramadan on 22/06/2026.
//

import Foundation
import Foundation

struct WeatherAPIResponse: Decodable {
    let location: APILocation
    let current: APICurrent
    let forecast: APIForecast
}

struct APILocation: Decodable {
    let name: String
    let localtime: String
}

struct APICurrent: Decodable {
    let temp_c: Double
    let condition: APICondition
    let humidity: Int
    let feelslike_c: Double
    let vis_km: Double
    let pressure_mb: Double
}

struct APICondition: Decodable {
    let text: String
}

struct APIForecast: Decodable {
    let forecastday: [APIForecastDay]
}

struct APIForecastDay: Decodable {
    let date: String
    let day: APIDay
    let hour: [APIHour]
}

struct APIDay: Decodable {
    let maxtemp_c: Double
    let mintemp_c: Double
    let condition: APICondition
}

struct APIHour: Decodable {
    let time: String
    let temp_c: Double
    let condition: APICondition
}
