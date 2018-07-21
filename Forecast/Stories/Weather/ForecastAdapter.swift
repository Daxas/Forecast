
import Foundation
import CoreLocation

class ForecastAdapter {
    
    typealias ForecastAdapterCompletion = (ForecastPoint) -> Void
    
    private let geoCoder = GeoCoder()
    private let geoLocator = GeoLocator()
    private let forecastClient = ForecastClient()
    
    
    func getForecastAndAddress(for location: CLLocation, completion: @escaping (ForecastPoint) -> Void,
                               failure: @escaping (Error) -> Void) {
        var favorPoint = ForecastPoint(with: location)
        getForecast(for: favorPoint, completion: { (point) in
            favorPoint = point
            self.getAddress(for: favorPoint, completion: { (point) in
                favorPoint = point
            }, failure: {print($0)})
            completion(favorPoint)
        }, failure: {print($0)})
        
    }
    
    func getForecastForCurrentPoint(completion: @escaping ForecastAdapterCompletion,
                                    failure: @escaping (Error) -> Void){
        getCurrentPoint(completion: { (point) in
            var currentPoint = point
            self.getForecast(for: point, completion: { (point) in
                currentPoint = point
                completion(currentPoint)
            }, failure: { print($0)
                print("222")
            })
        }, failure: { print($0)
            print("NO getForecastForCurrentPoint")
        })
    }
    
    
    func getCurrentPoint(completion: @escaping ForecastAdapterCompletion,
                         failure: @escaping (Error) -> Void){
        geoLocator.requestLocation { (location, error) in
            if let error = error  {
                print(error)
                print("111")
                return
            }
            guard let location = location else {
                return
            }
            let point = ForecastPoint(with: location)
            self.getAddress(for: point, completion: { (address) in
                completion(point)
            }, failure: { (error) in
                print("error getCurrentPoint")
            })
        }
    }
    
    func getAddress(for point: ForecastPoint, completion: @escaping ForecastAdapterCompletion,
                    failure: @escaping (Error) -> Void){
        geoCoder.geoCode(for: point.location, completion: { (placemarks) in
            for placemark in placemarks {
                if let address = ForecastAddress(with: placemark){
                    point.address = address
                    completion(point)
                }
            }
        }, failure: { print($0)
            print("NO adress for current point")
        })
    }
    
    func getForecast(for point: ForecastPoint, completion: @escaping ForecastAdapterCompletion,
                     failure: @escaping (Error) -> Void){
        forecastClient.getForecast(for: point.location, completion: { (forecast) in
            point.forecast = forecast
            completion(point)
        }) { (error) in
            print("NO forecast for current point")
        }
    }
    
    
}
