import Foundation
import CoreLocation

enum GeoLocatorError: String, Error {
    case disableLocator = "Location service disabled"
    case locationError = "Did fail location"
}

class GeoLocator: NSObject, CLLocationManagerDelegate {
    
  typealias GeoLocatorCompletion = (CLLocation?, Error?) -> Void
    
    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        return manager
    }()
    
    private var completion: GeoLocatorCompletion?
    
    func requestLocation(completion: @escaping GeoLocatorCompletion){
        //TODO: handle authorization
        locationManager.requestWhenInUseAuthorization()
        guard CLLocationManager.locationServicesEnabled() else {
            print(GeoLocatorError.disableLocator.rawValue)
            return
        }
        self.completion = completion
        locationManager.startUpdatingLocation()
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        completion?(nil, error)
        print(GeoLocatorError.locationError.rawValue)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.last {
            locationManager.stopUpdatingLocation()
            completion?(currentLocation, nil)
            print("user longitude = \(currentLocation.coordinate.longitude)")
        }
    }
    
}


