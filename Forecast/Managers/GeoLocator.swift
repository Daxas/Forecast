
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
 //   private var currentLocation: CLLocation?
    
    func requestLocation(completion: @escaping GeoLocatorCompletion){
        CLLocationManager.authorizationStatus()
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
        //completion = nil
        print(GeoLocatorError.locationError.rawValue)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.last {
            locationManager.stopUpdatingLocation()
            completion?(currentLocation, nil)
          //  completion = nil
           
            print("user longitude = \(currentLocation.coordinate.longitude)")
        }
    }
    
}


