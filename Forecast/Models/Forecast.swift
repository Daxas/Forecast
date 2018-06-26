import Foundation
import Mapper

class Forecast: Mappable {
    
    let summary: String
    let icon: String
    let temperature: Double
    let humidity: Double
    let pressure: Double
    let windSpeed: Double
    
    let hourlyData: [HourlyWeatherDataPoint]
    let dailyData: [DailyWeatherDataPoint]
    
   required init(map: Mapper) throws {
        summary = try map.from("currently.summary")
        icon = try map.from("currently.icon")
        temperature = try map.from("currently.temperature")
        humidity = try map.from("currently.humidity")
        pressure = try map.from("currently.pressure")
        windSpeed = try map.from("currently.windSpeed")
    
        hourlyData = try map.from("hourly.data")
        dailyData = try map.from("daily.data")
    }
    
}

