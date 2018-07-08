
import Foundation
import CoreLocation

class GeoLocator: NSObject, CLLocationManagerDelegate {
    
    lazy var locationManager = CLLocationManager()
    var location: CLLocation?
   var updatingLocation = false
   var lastLocationError: Error?
    var forecastVC = ForecastViewController()
   
    
    func getLocation(){
        let authStatus = CLLocationManager.authorizationStatus()
        if authStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        if authStatus == .denied || authStatus == .restricted {
            print("Location Services Disabled")
            return
        }
        startLocationManager()
       // let userLocation = location
        //completion(location)
    }
    
    private func stopLocationManager() {
        if updatingLocation {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            updatingLocation = false
        }
    }
    
   private func startLocationManager() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            updatingLocation = true
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        print("didFailWithError \(error)")
        if (error as NSError).code == CLError.locationUnknown.rawValue {
            return
        }
        lastLocationError = error
        stopLocationManager()
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        location = locations.last!
       
        print("user longitude = \(location?.coordinate.longitude)")
        forecastVC.recevedLocation(location: location)
        
        lastLocationError = nil
    }
    
   
    
    }

    
   /* func showLocationServicesDeniedAlert() {
        let alert = UIAlertController(title: "Location Services Disabled",
                                      message:
            "Please enable location services for this app in Settings.",
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default,
                                     handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    */

