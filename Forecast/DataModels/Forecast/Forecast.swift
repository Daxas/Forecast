import Foundation

struct Forecast: Decodable {
    let currently: CurrentlyForecast
    let hourly: HourlyForecast
    let daily: DailyForecast
}
    
struct CurrentlyForecast: Decodable {
    let summary: String
    let icon: String
    let temperature: Double
    let humidity: Double
    let pressure: Double
    let windSpeed: Double
}

struct HourlyForecast: Decodable {
    let data: [Hourly]
}

struct DailyForecast: Decodable {
    let data: [Daily]
}

struct Hourly: Decodable {
    let time: TimeInterval
    let temperature: Double
    let icon: String
}

struct Daily: Decodable {
    let time: TimeInterval
    let temperatureMin: Double
    let temperatureMax: Double
    let icon: String
}
