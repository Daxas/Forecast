
import Foundation
import CoreLocation

class ForecastPoint: NSObject/*, NSCoding*/ {
    
    let location: CLLocation
    var address: ForecastAddress?
    var forecast: Forecast?
    
    init(with location: CLLocation, placemark: CLPlacemark? = nil) {
        self.location = location
        if let placemark = placemark {
            self.address = ForecastAddress(with: placemark)
        }
    }
    
  /*  required init?(coder aDecoder: NSCoder) {
        location = aDecoder.decodeObject(forKey: "Location") as! CLLocation
        address = aDecoder.decodeObject(forKey: "Address") as? ForecastAddress
        forecast = aDecoder.decodeObject(forKey: "Forecast") as? Forecast
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(location, forKey: "Location")
        aCoder.encode(address, forKey: "Address")
        aCoder.encode(forecast, forKey: "Forecast")
    }*/
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




    
    


