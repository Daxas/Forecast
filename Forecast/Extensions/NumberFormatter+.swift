import Foundation

extension NumberFormatter {
    
    func getTemperatureFrom(number temperature: Double) -> String {
        
        let temp = temperature.rounded()
        let measurement = Measurement(value: temp, unit: UnitTemperature.celsius)
        let measurementFormatter = MeasurementFormatter()
        measurementFormatter.unitOptions = .providedUnit
        var strTemperature = measurementFormatter.string(from: measurement)
        strTemperature = temperature > 0 ? "+" + strTemperature : strTemperature
        return strTemperature
    }
    
}

