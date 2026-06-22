import Foundation
 
struct WeatherCondition: Hashable {
    let label: String
    let sfSymbol: String
}
 
struct WeatherMetric: Identifiable {
    let id = UUID()
    let title: String
    let value: String
    let unit: String
    let sfSymbol: String
}
 
struct DailyForecast: Identifiable {
    let id = UUID()
    let dayLabel: String
    let condition: WeatherCondition
    let low: Double
    let high: Double
}
 
struct HourlyWeather: Identifiable {
    let id = UUID()
    let label: String
    let condition: WeatherCondition
    let temperature: Int
}
 
struct CityWeather: Identifiable, Equatable {
    let id = UUID()
    let city: String
    let temperature: Int
    let condition: WeatherCondition
    let high: Int
    let low: Int
 
    static func == (lhs: CityWeather, rhs: CityWeather) -> Bool {
        lhs.city == rhs.city
    }
}
 
 
enum MockWeather {
    static let partlyCloudy = WeatherCondition(label: "Partly Cloudy", sfSymbol: "cloud.sun.fill")
    static let rainy        = WeatherCondition(label: "Rainy",         sfSymbol: "cloud.rain.fill")
    static let sunny        = WeatherCondition(label: "Sunny",         sfSymbol: "sun.max.fill")
    static let cloudy       = WeatherCondition(label: "Cloudy",        sfSymbol: "cloud.fill")
    static let clearNight   = WeatherCondition(label: "Clear",         sfSymbol: "moon.stars.fill")
    static let windy        = WeatherCondition(label: "Windy",         sfSymbol: "wind")
 
    static let cairo  = CityWeather(city: "Cairo",    temperature: 21, condition: partlyCloudy, high: 16, low: 6)
    static let london = CityWeather(city: "London",   temperature: 11, condition: rainy,        high: 13, low: 7)
    static let tokyo  = CityWeather(city: "Tokyo",    temperature: 18, condition: sunny,        high: 22, low: 12)
    static let nyc    = CityWeather(city: "New York", temperature: 8,  condition: windy,        high: 10, low: 3)
 
    static let allCities: [CityWeather] = [cairo, london, tokyo, nyc]
 
    static let threeDayForecast: [DailyForecast] = [
        DailyForecast(dayLabel: "Today", condition: partlyCloudy, low: 7.8, high: 15.5),
        DailyForecast(dayLabel: "Wed",   condition: rainy,        low: 6.4, high: 16.1),
        DailyForecast(dayLabel: "Thu",   condition: sunny,        low: 8.7, high: 17.8)
    ]
 
    static let todayHourly: [HourlyWeather] = [
        HourlyWeather(label: "Now", condition: partlyCloudy, temperature: 15),
        HourlyWeather(label: "3PM", condition: partlyCloudy, temperature: 15),
        HourlyWeather(label: "4PM", condition: cloudy,       temperature: 14),
        HourlyWeather(label: "5PM", condition: cloudy,       temperature: 13),
        HourlyWeather(label: "6PM", condition: clearNight,   temperature: 12)
    ]
 
    static let metrics: [WeatherMetric] = [
        WeatherMetric(title: "VISIBILITY", value: "10", unit: "km", sfSymbol: "eye.fill"),
        WeatherMetric(title: "HUMIDITY", value: "36", unit: "%", sfSymbol: "humidity.fill"),
        WeatherMetric(title: "FEELS LIKE", value: "16", unit: "°", sfSymbol: "thermometer.medium"),
        WeatherMetric(title: "PRESSURE", value: "1,021", unit: "hPa", sfSymbol: "gauge.with.dots.needle.50percent")
    ]
}
