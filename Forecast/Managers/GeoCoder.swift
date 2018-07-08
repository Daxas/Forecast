import Foundation
import CoreLocation

enum GeoCoderError: String, Error {
    case noPlacesFound = "No Matching Addresses Found"
}

class GeoCoder {
    
    func geoCode(for location: CLLocation, completion: @escaping ([String]) -> Void,
                 failure: @escaping (Error) -> Void){
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) in
            if let error = error {
                failure(error)
                return
            }
            let currentAddress = self.processResponse(with: placemarks)
            completion(currentAddress)
        })
        return
    }
    
    private func processResponse(with placemarks: [CLPlacemark]?) -> [String] {
        guard let placemarks = placemarks else {
            return [GeoCoderError.noPlacesFound.rawValue]
        }
        var address = [String]()
        for placemark in placemarks {
            if let locality = placemark.locality, let subAdministrativeArea = placemark.subAdministrativeArea,
                let thoroughfare = placemark.thoroughfare {
            address.append(locality)
            address.append(subAdministrativeArea + ", " + thoroughfare)
            }
        }
        return address
    }
    
}
