
import Foundation
import CoreLocation

class ForecastPoint: NSObject {
    
    let location: CLLocation
    var address: ForecastAddress?
    var forecast: Forecast?
    
    init(with location: CLLocation, placemark: CLPlacemark? = nil) {
        self.location = location
        if let placemark = placemark {
            self.address = ForecastAddress(with: placemark)
        }
    }
}


class ForecastAddress {
    
    let city: String
    let detail: String
    
    init?(with placemark: CLPlacemark) {
        guard let city = placemark.locality, let detail = placemark.thoroughfare else {
            return nil
        }
        self.city = city
        self.detail = detail
    }
    
}
