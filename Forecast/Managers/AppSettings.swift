
import CoreLocation
import Foundation

class AppSettings {
    
    func setSelectedCoordinates(forecastPoint: ForecastPoint?) {
        guard let point = forecastPoint else {
            UserDefaults.standard.set(nil, forKey: "SelectedLocationCoordinates")
            return
        }
           var coordinates = [Double]()
            coordinates.append(point.location.coordinate.latitude)
            coordinates.append(point.location.coordinate.longitude)
            UserDefaults.standard.set(coordinates, forKey: "SelectedLocationCoordinates")
        
    }
    
    func getSelectedCoordinates() -> CLLocation? {
        guard let coordinates = UserDefaults.standard.array(forKey: "SelectedLocationCoordinates") as? [CLLocationDegrees] else {
            return nil
        }
            return CLLocation(latitude: coordinates[0] , longitude: coordinates[1])
    }
    
}
