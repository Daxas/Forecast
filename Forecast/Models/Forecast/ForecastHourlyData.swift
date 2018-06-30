
import Foundation
import Mapper

struct ForecastHourlyData: Mappable {
    
    let time: Int
    let temperature: Double
    let icon: String
    
    init() {
        time = 0
        temperature = 0
        icon = ""
    }
    
    init(map: Mapper) throws {
        time = try map.from("time")
        temperature = try map.from("temperature")
        icon = try map.from("icon")
    }
    
}
