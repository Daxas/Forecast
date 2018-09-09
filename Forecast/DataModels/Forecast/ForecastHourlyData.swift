
import Foundation
import Mapper

struct ForecastHourlyData: Mappable {
    
    let time: Date
    let temperature: Double
    let icon: String
    
    init(map: Mapper) throws {
        do {
            time = try map.from("time", transformation: { time -> Date in
                guard let time = time as? Int else {
                    return Date()
                }
                return Date(timeIntervalSince1970: Double(time))
            })
            temperature = try map.from("temperature")
            icon = try map.from("icon")
        } catch {
            throw error
        }
    }
    
}
