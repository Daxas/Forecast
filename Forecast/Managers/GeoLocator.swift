
import Foundation
import CoreLocation

protocol GeoLocatorDelegate: class {
    func geoLocatorGetLocation(_ geoLocator: GeoLocator, didReceved location: CLLocation)
}

enum GeoLocatorError: String, Error {
    case disableLocator = "Location service disabled"
    case locationError = "Did fail location"
}

class GeoLocator: NSObject, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    weak var delegate: GeoLocatorDelegate?
    
    func getLocation(){
        CLLocationManager.authorizationStatus()
        guard CLLocationManager.locationServicesEnabled() else {
            print(GeoLocatorError.disableLocator.rawValue)
            return
        }
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }
    
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(GeoLocatorError.locationError.rawValue)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.last {
            locationManager.stopUpdatingLocation()
            delegate?.geoLocatorGetLocation(self, didReceved: currentLocation)
            print("user longitude = \(currentLocation.coordinate.longitude)")
        }
    }
    
}


