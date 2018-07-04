

import Foundation
//import MapKit
import CoreLocation

class GeoCoder {
    private var text = "-.-"
    
    func geoCode(for location: CLLocation) -> String {
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) in
            self.processResponse(with: placemarks, error: error)
        })
        return text
    }
    
    private func processResponse(with placemarks: [CLPlacemark]?, error: Error?){
        guard error == nil else {
             text = "Unable to Find Address for Location"
            return
        }
        guard let placemarks = placemarks else {
            text = "No Matching Addresses Found"
            return
        }
        var adress = ""
        for placemark in placemarks {
            adress.append(placemark.locality! + ", " + placemark.thoroughfare!)
        }
        text = adress
        }
    
}
