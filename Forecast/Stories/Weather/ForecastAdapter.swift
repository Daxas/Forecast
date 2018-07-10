
import Foundation
import CoreLocation

class ForecastAdapter {
    
    private var forecastPoint: ForecastPoint?
    private let geoCoder = GeoCoder()
    private let geoLocator = GeoLocator()
    private let forecastClient = ForecastClient()
    
    func getCurrentForecast(completion: @escaping (ForecastPoint) -> Void,
                            failure: @escaping (Error) -> Void){
        getCurrentPoint(completion: {point in
            self.forecastPoint = point
            self.getForecast(for: point, completion: {forecast in
                self.forecastPoint?.forecast = forecast
            } , failure: failure)
        }, failure: failure)
    }
    
    func getCurrentPoint(completion: @escaping (ForecastPoint) -> Void,
                         failure: @escaping (Error) -> Void){
        geoLocator.requestLocation(completion: {(location, error) in
            if let error = error {
                failure(error)
                return
            }
            guard let location = location else {
                return
            }
            let point = ForecastPoint(with: location)
    
        self.getAddress(for: point, completion: {address in
            point.address = address
            completion(point)
        }, failure: failure)
        })
    }
    
   
    
    func getAddress(for point: ForecastPoint, completion: @escaping (ForecastAddress) -> Void,
                    failure: @escaping (Error) -> Void){
        geoCoder.geoCode(for: point.location, completion: { placemarks in
            for placemark in placemarks {
            if let address = ForecastAddress(with: placemark) {
                completion(address)
            }
            }
        }, failure: {print($0)})
    }
    
    func getForecast(for point: ForecastPoint, completion: @escaping (Forecast) -> Void,
                     failure: @escaping (Error) -> Void){
        forecastClient.getForecast(for: point.location, completion: {
            completion($0)
        }, failure: {print($0)})
    }
    
    
    
    /*func geoLocatorGetLocation(_ geoLocator: GeoLocator, didReceved location: CLLocation) {
        self.location = location
        //fetchAddress(location: location)
       // fetchForecast(location: location)
    }
    */
    
  /*  private func fetchForecast(location: CLLocation) {
        forecastClient.getForecast(for: location, completion: {[weak self] in
            self?.forecast = $0
            self?.delegate?.forecastAdapterDelegate(self!, didReceved: $0)
            } , failure: {print($0)})
    }
    
   private func fetchAddress(location: CLLocation) {
        geoCoder.geoCode(for: location, completion: {[weak self] in
            self?.adaptAddress(address: $0)
            }, failure: {print($0)})
    }
    
    private func adaptAddress(address: [String]) {
        self.address.append(address[0])
        self.address.append(address[1])
        delegate?.forecastAdapterDelegate(self, didReceved: self.address)
    }
    */
}
