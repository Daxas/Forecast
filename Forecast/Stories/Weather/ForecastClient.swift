
import Foundation
import Mapper
import MapKit

enum ForecastClientError: Error {
    case urlError
    case responceError
    case mappingError
}

class ForecastClient {
    
    struct Configuration {
        static var apiKey = "cfb098593c0899de76d374e96d68c8e3"
        static let baseURL = "https://api.forecast.io/forecast/"
    }
    
    private let urlSession = URLSession.shared
    private var dataTask: URLSessionDataTask?
    
    private var baseURL: String {
        return Configuration.baseURL + Configuration.apiKey
    }
    
    private func forecastURL(for coordinate: CLLocationCoordinate2D) -> URL? {
        let path = baseURL + "/" + "56.23,43.411"
       //let path = baseURL + "/" + String(format: "%2.2d, %2.2d", coordinate.latitude, coordinate.longitude)
        
        return URL(string: path)
    }
    
    func getForecast(for location: CLLocationCoordinate2D,
                     completion: @escaping (Forecast) -> Void,
                     failure: @escaping (Error) -> Void) {
        
        guard let url = forecastURL(for: location) else {
            failure(ForecastClientError.urlError)
            return
        }
       
       // let queue = DispatchQueue.global()
      // queue.async {
       dataTask = urlSession.dataTask(with: url) { (data, response, error) in
        
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                        failure(ForecastClientError.responceError)
                        return
                }
        if let data = data {
                 do {
                let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                        
                    guard let json = jsonData, let forecast = Forecast.from(json) else {
                        failure(ForecastClientError.mappingError)
                        return
                    }
                    completion(forecast)
                        
                 } catch {
                    failure(error)
                }
        }
        
        }
        dataTask?.resume()

    }
}

    

