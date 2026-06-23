//
//  SearchResult.swift
//  WeatherCastApp
//
//  Created by shady ramadan on 23/06/2026.
//

import Foundation

struct SearchResult: Identifiable, Decodable {
    let id: Int
    let name: String
    let region: String
    let country: String
    let lat: Double
    let lon: Double
}
