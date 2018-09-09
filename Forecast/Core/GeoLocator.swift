import Foundation
import CoreLocation

enum GeoLocatorError: String, Error {
    case disableLocator = "Location service disabled"
    case locationError  = "Did fail location"
}

class GeoLocator: NSObject, CLLocationManagerDelegate {
    
  typealias GeoLocatorCompletion = (CLLocation?, Error?) -> Void
    
    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
        return manager
    }()
    
    private var completion: GeoLocatorCompletion?
    
    func requestLocation(completion: @escaping GeoLocatorCompletion){
        let authStatus = CLLocationManager.authorizationStatus()
        if authStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        if authStatus == .denied || authStatus == .restricted {
            print(GeoLocatorError.disableLocator.rawValue)
            return
        }
        self.completion = completion
        locationManager.startUpdatingLocation()
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
       print(GeoLocatorError.locationError.rawValue)
        if (error as NSError).code == CLError.locationUnknown.rawValue {
            return
        }
        locationManager.stopUpdatingLocation()
        completion?(nil, error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        print("user longitude = \(newLocation.coordinate.longitude)")
        if newLocation.timestamp.timeIntervalSinceNow < -10 {
            return
        }
            locationManager.stopUpdatingLocation()
            completion?(newLocation, nil)
    }
    
}


