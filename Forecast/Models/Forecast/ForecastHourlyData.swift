
import Foundation
import Mapper

struct ForecastHourlyData: Mappable {
    
    let time: Int
    let temperature: Double
    let icon: String
    
    init(map: Mapper) throws {
        time = try map.from("time")
        temperature = try map.from("temperature")
        icon = try map.from("icon")
    }
    
}
