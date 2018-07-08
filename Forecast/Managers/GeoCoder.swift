import Foundation
import CoreLocation

enum GeoCoderError: String, Error {
    case noPlacesFound = "No Matching Addresses Found"
}

class GeoCoder {
    private var text = "-.-"
    
    func geoCode(for location: CLLocation, completion: @escaping (String) -> Void,
                 failure: @escaping (Error) -> Void) -> String {
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) in
            if let error = error {
                failure(error)
                return
            }
            self.text = self.processResponse(with: placemarks)
            completion(self.text)
            //
            //self.text = address
        })
        return text
    }
    
    private func processResponse(with placemarks: [CLPlacemark]?) -> String {
        guard let placemarks = placemarks else {
            return GeoCoderError.noPlacesFound.rawValue
        }
        var adress = ""
        for placemark in placemarks {
            adress.append(placemark.locality! + ", " + placemark.thoroughfare!)
        }
        return adress
    }
    
}
