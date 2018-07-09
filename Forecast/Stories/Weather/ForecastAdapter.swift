
import Foundation
import CoreLocation

protocol ForecastAdapterDelegate: class {
    func forecastAdapterDelegate(_ forecastAdapter: ForecastAdapter, didReceved address: [String])
    func forecastAdapterDelegate(_ forecastAdapter: ForecastAdapter, didReceved forecast: Forecast)
}

class ForecastAdapter: GeoLocatorDelegate {
    
    var forecast: Forecast?
    var address = [String]()
    weak var delegate: ForecastAdapterDelegate?
    
    private var location: CLLocation?
    private let geoCoder = GeoCoder()
    private let geoLocator = GeoLocator()
    private let forecastClient = ForecastClient()
    
    func geoLocatorGetLocation(_ geoLocator: GeoLocator, didReceved location: CLLocation) {
        self.location = location
        fetchAddress(location: location)
        fetchForecast(location: location)
    }
    
    
    private func fetchForecast(location: CLLocation) {
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
    
}
