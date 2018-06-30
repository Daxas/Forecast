
import Foundation
import Mapper

struct ForecastDailyData: Mappable {
    
    let time: Int
    let minTemp: Double
    let maxTemp: Double
    let icon: String
    
    init() {
        time = 0
        minTemp = 0
        maxTemp = 0
        icon = ""
    }
    
    init(map: Mapper) throws {
        time = try map.from("time")
        minTemp = try map.from("temperatureLow")
        maxTemp = try map.from("temperatureHigh")
        icon = try map.from("icon")
    }
    
}
