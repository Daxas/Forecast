
import Foundation
import Mapper

struct ForecastDailyData: Mappable {
    
    let time: Date
    let minTemp: Double
    let maxTemp: Double
    let icon: String
    
    init(map: Mapper) throws {
        do {
            time = try map.from("time", transformation: { time -> Date in
                guard let time = time as? Int else {
                    return Date()
                }
                return Date(timeIntervalSince1970: Double(time))
            })
            minTemp = try map.from("temperatureLow")
            maxTemp = try map.from("temperatureHigh")
            icon = try map.from("icon")
        } catch {
            throw error
        }
    }
    
}



