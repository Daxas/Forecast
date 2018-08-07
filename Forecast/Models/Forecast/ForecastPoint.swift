
import Foundation
import CoreLocation

class ForecastPoint: NSObject, NSCoding {
    
    
    
    let location: CLLocation
    var address: ForecastAddress?
    var forecast: Forecast?
    
    init(with location: CLLocation, placemark: CLPlacemark? = nil) {
        self.location = location
        if let placemark = placemark {
            self.address = ForecastAddress(with: placemark)
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(location, forKey: "Location")
        aCoder.encode(address, forKey: "Address")
    }
    
    required init?(coder aDecoder: NSCoder) {
        location = aDecoder.decodeObject(forKey: "Location") as! CLLocation
        address = aDecoder.decodeObject(forKey: "Address") as? ForecastAddress
        super.init()
    }
    
}


class ForecastAddress: NSObject, NSCoding {
   
    let city: String
    let detail: String
    
    init?(with placemark: CLPlacemark) {
        guard let city = placemark.locality else {
            return nil
        }
        self.city = city
        guard let detail = placemark.thoroughfare else {
            self.detail = "Somewhere".localized()
            return
        }
        self.detail = detail
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(city, forKey: "City")
        aCoder.encode(detail, forKey: "Detail")
    }
    
    required init?(coder aDecoder: NSCoder) {
        city = aDecoder.decodeObject(forKey: "City") as! String
        detail = aDecoder.decodeObject(forKey: "Detail") as! String
        super.init()
    }
}




    
    


