
import Foundation
import Mapper

struct DailyWeatherDataPoint: Mappable {
    
    let time: Int
    let minTemp: Double
    let maxTemp: Double
    let icon: String
    
    init(map: Mapper) throws {
        time = try map.from("time")
        minTemp = try map.from("temperatureLow")
        maxTemp = try map.from("temperatureHigh")
        icon = try map.from("icon")
    }
    
}
