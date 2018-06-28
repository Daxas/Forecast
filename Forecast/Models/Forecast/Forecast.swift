import Foundation
import Mapper

class Forecast: Mappable {
    
    let summary: String
    let icon: String
    let temperature: Double
    let humidity: Double
    let pressure: Double
    let windSpeed: Double
    
    var hourlyData = [ForecastHourlyData]()
    var dailyData = [ForecastDailyData ]()
    
   required init(map: Mapper) throws {
    
        try summary = map.from("currently.summary")
        try icon = map.from("currently.icon")
        try temperature = map.from("currently.temperature")
        try humidity = map.from("currently.humidity")
        try pressure = map.from("currently.pressure")
        try windSpeed = map.from("currently.windSpeed")
        
        hourlyData = map.optionalFrom("hourly.data") ?? [ForecastHourlyData]()
        dailyData = map.optionalFrom("daily.data") ?? [ForecastDailyData]()
    }
    
}

