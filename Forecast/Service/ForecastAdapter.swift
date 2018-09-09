
import Foundation
import CoreLocation

typealias ForecastAdapterCompletion = (ForecastPoint) -> Void

protocol ForecastAdapterProtocol: class {
   // func getForecastAndAddress(for forecastPoint: ForecastPoint, completion: @escaping ForecastAdapterCompletion,
    //                           failure: @escaping (Error) -> Void)
    func getForecastForCurrentPoint(completion: @escaping ForecastAdapterCompletion,
                                    failure: @escaping (Error) -> Void)
    
   // func getCurrentPoint(completion: @escaping ForecastAdapterCompletion,
    //                     failure: @escaping (Error) -> Void)
    func getAddress(for point: ForecastPoint, completion: @escaping ForecastAdapterCompletion,
                    failure: @escaping (Error) -> Void)
    func getForecast(for point: ForecastPoint, completion: @escaping ForecastAdapterCompletion,
                     failure: @escaping (Error) -> Void)
}

class ForecastAdapter: ForecastAdapterProtocol {
    
    var geoCoder: GeoCoder
    var geoLocator: GeoLocator
    var forecastClient: ForecastClient
    
    init(geoCoder: GeoCoder, geoLocator: GeoLocator, forecastClient: ForecastClient) {
        self.geoCoder = geoCoder
        self.geoLocator = geoLocator
        self.forecastClient = forecastClient
    }
    
    private func getForecastAndAddress(for forecastPoint: ForecastPoint, completion: @escaping ForecastAdapterCompletion,
                               failure: @escaping (Error) -> Void) {
        getAddress(for: forecastPoint, completion: { (point) in
            forecastPoint.address = point.address
            self.getForecast(for: point, completion: { (point) in
                forecastPoint.forecast = point.forecast
                completion(forecastPoint)
            }, failure: { print($0)})
        }, failure: { print($0)})
    }
    
    func getForecastForCurrentPoint(completion: @escaping ForecastAdapterCompletion,
                                    failure: @escaping (Error) -> Void){
        getCurrentPoint(completion: { (point) in
            var currentPoint = point
            self.getForecast(for: point, completion: { (point) in
                currentPoint = point
                completion(currentPoint)
            }, failure: { print($0)
                print("getForecast error")
            })
        }, failure: { print($0)
            print("getCurrentPoint error: NO getForecastForCurrentPoint")
        })
    }
    
    
    private func getCurrentPoint(completion: @escaping ForecastAdapterCompletion,
                         failure: @escaping (Error) -> Void){
        geoLocator.requestLocation { (location, error) in
            if let error = error  {
                print(error)
                print("geoLocator.requestLocation error")
                return
            }
            guard let location = location else {
                return
            }
            let point = ForecastPoint(with: location)
            self.getAddress(for: point, completion: { (address) in
                completion(point)
            }, failure: { (error) in
                print("get address error: getCurrentPoint")
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
            print("getAddress - geoCoder.geoCode: NO adress for current point")
        })
    }
    
    func getForecast(for point: ForecastPoint, completion: @escaping ForecastAdapterCompletion,
                     failure: @escaping (Error) -> Void){
        forecastClient.getForecast(for: point.location, completion: { (forecast) in
            point.forecast = forecast
            completion(point)
        }) { (error) in
            print("getForecast: NO forecast for current point")
        }
    }
    
}
