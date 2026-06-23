import Foundation
class WeatherService: WeatherServiceProtocol {
    private let apiKey = "15a27e37377d435f91e205319262501"
    
    func fetchWeather(for city: String) async throws -> WeatherResult {
        let encodedCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? city
        let urlString = "https://api.weatherapi.com/v1/forecast.json?key=\(apiKey)&q=\(encodedCity)&days=3&aqi=no&alerts=no"
        return try await fetchAndParse(urlString: urlString)
    }
    
    func fetchWeather(lat: Double, lon: Double) async throws -> WeatherResult {
        let urlString = "https://api.weatherapi.com/v1/forecast.json?key=\(apiKey)&q=\(lat),\(lon)&days=3&aqi=no&alerts=no"
        return try await fetchAndParse(urlString: urlString)
    }
    
    func searchCities(query: String) async throws -> [SearchResult] {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        let urlString = "https://api.weatherapi.com/v1/search.json?key=\(apiKey)&q=\(encodedQuery)"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([SearchResult].self, from: data)
    }
    
    // MARK: - Private Helpers
    
    private func fetchAndParse(urlString: String) async throws -> WeatherResult {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(WeatherAPIResponse.self, from: data)
        
        let conditionLabel = response.current.condition.text
        let sfSymbol = mapConditionToSymbol(conditionLabel)
        let weatherCondition = WeatherCondition(label: conditionLabel, sfSymbol: sfSymbol)
        
        let rawLocalTime = response.location.localtime
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm"
                
                var timeString = "00:00"
                var hourInt = Calendar.current.component(.hour, from: Date())
                
                if let date = formatter.date(from: rawLocalTime) {
                    let timeFormatter = DateFormatter()
                    timeFormatter.dateFormat = "HH:mm"
                    timeString = timeFormatter.string(from: date)
                    hourInt = Calendar.current.component(.hour, from: date)
                }
                
                let currentCityWeather = CityWeather(
                    city: response.location.name,
                    temperature: Int(response.current.temp_c),
                    condition: weatherCondition,
                    high: Int(response.forecast.forecastday.first?.day.maxtemp_c ?? 0),
                    low: Int(response.forecast.forecastday.first?.day.mintemp_c ?? 0),
                    formattedLocalTime: timeString,
                    localHour: hourInt
                )
        
        let dailyForecasts = response.forecast.forecastday.map { dayData in
            let label = parseDayName(from: dayData.date)
            let daySymbol = mapConditionToSymbol(dayData.day.condition.text)
            return DailyForecast(
                dayLabel: label,
                condition: WeatherCondition(label: dayData.day.condition.text, sfSymbol: daySymbol),
                low: dayData.day.mintemp_c,
                high: dayData.day.maxtemp_c
            )
        }
        
        let hourlyForecasts = (response.forecast.forecastday.first?.hour ?? []).map { hourData in
            let label = parseHourName(from: hourData.time)
            let hourSymbol = mapConditionToSymbol(hourData.condition.text)
            return HourlyWeather(
                label: label,
                condition: WeatherCondition(label: hourData.condition.text, sfSymbol: hourSymbol),
                temperature: Int(hourData.temp_c)
            )
        }
        
        let metrics = [
            WeatherMetric(title: "VISIBILITY", value: "\(Int(response.current.vis_km))", unit: "km", sfSymbol: "eye.fill"),
            WeatherMetric(title: "HUMIDITY", value: "\(response.current.humidity)", unit: "%", sfSymbol: "drop.fill"),
            WeatherMetric(title: "FEELS LIKE", value: "\(Int(response.current.feelslike_c))", unit: "°", sfSymbol: "thermometer.medium"),
            WeatherMetric(title: "PRESSURE", value: "\(Int(response.current.pressure_mb))", unit: "hPa", sfSymbol: "gauge.with.needle")
        ]
        
        return WeatherResult(
            cityWeather: currentCityWeather,
            dailyForecast: dailyForecasts,
            hourlyForecast: hourlyForecasts,
            metrics: metrics
        )
    }
    
    private func mapConditionToSymbol(_ text: String) -> String {
        let lower = text.lowercased()
        if lower.contains("sunny") || lower.contains("clear") { return "sun.max.fill" }
        if lower.contains("partly cloudy") { return "cloud.sun.fill" }
        if lower.contains("cloudy") || lower.contains("overcast") { return "cloud.fill" }
        if lower.contains("rain") || lower.contains("drizzle") { return "cloud.rain.fill" }
        if lower.contains("snow") { return "snowflake" }
        return "cloud.fill"
    }
    
    private func parseDayName(from dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: dateString) else { return dateString }
        if Calendar.current.isDateInToday(date) { return "Today" }
        formatter.dateFormat = "E"
        return formatter.string(from: date)
    }
    
    private func parseHourName(from timeString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        guard let date = formatter.date(from: timeString) else { return timeString }
        formatter.dateFormat = "ha"
        return formatter.string(from: date)
    }
}
