
import Foundation

class TemperatureUtils {
    
    func getTemperatureFrom(number temperature: Double) -> String {
        let stringTemp = String(Int(temperature.rounded())) + "º"
        return temperature > 0 ? "+" + stringTemp : stringTemp
    }
    
}
