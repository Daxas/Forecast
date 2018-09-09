import Foundation
import CoreLocation

enum GeoCoderError: String, Error {
    case noPlacesFound = "No Matching Addresses Found"
}

class GeoCoder {
    
    func geoCode(for location: CLLocation, completion: @escaping ([CLPlacemark]) -> Void,
                 failure: @escaping (Error) -> Void){
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) in
            if let error = error {
                print("geoCode error")
                failure(error)
                return
            }
            guard let placemarks = placemarks else {
                return 
            }
            completion(placemarks)
        })
        return
    }
    
    func geoSearching(for text: String, completion: @escaping ([CLPlacemark]) -> Void,
                      failure: @escaping (Error) -> Void){
        CLGeocoder().geocodeAddressString(text, completionHandler: {(placemarks, error) in
            if let error = error {
                print("geoSearching error")
                failure(error)
                return
            }
            guard let placemarks = placemarks else {
                return
            }
            completion(placemarks)
        })
        return
    }
    
}





