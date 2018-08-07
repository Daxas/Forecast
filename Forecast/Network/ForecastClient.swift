
import Foundation
import Mapper
import MapKit

enum ForecastClientError: Error {
    case urlError
    case responceError
    case mappingError
    case dataError
}

class ForecastClient {
    
    struct Configuration {
        static var apiKey   = "cfb098593c0899de76d374e96d68c8e3"
        static let baseURL  = "https://api.forecast.io/forecast/"
        static let language = "en".localized()
    }
    
    private let urlSession = URLSession.shared
    private var dataTask: URLSessionDataTask?
    
    private var baseURL: String {
        return Configuration.baseURL + Configuration.apiKey
    }
    
    private func forecastURL(for location: CLLocation) -> URL? {
        let lat = String(format: "%.3f", location.coordinate.latitude)
        let long = String(format: "%.3f", location.coordinate.longitude)
        let path = baseURL + "/" + lat + "," + long + "?units=si" + "&lang=" + Configuration.language
        return URL(string: path)
    }
    
    func getForecast(for location: CLLocation,
                     completion: @escaping (Forecast) -> Void,
                     failure: @escaping (Error) -> Void) {
        
        guard let url = forecastURL(for: location) else {
            DispatchQueue.main.async {
                print("url error")
                failure(ForecastClientError.urlError)
            }
            return
        }
        
        dataTask = urlSession.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                DispatchQueue.main.async {
                    print("Forecast request error: error dataTask")
                    failure(ForecastClientError.dataError)
                }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    print("Forecast request error: no data")
                    failure(ForecastClientError.dataError)
                }
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                DispatchQueue.main.async {
                    print("Forecast request error: no httpResponse")
                    failure(ForecastClientError.responceError)
                }
                return
            }
            do {
                let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                
                guard let json = jsonData, let forecast = Forecast.from(json) else {
                    DispatchQueue.main.async {
                        print("Forecast request error: can't convert JSON")
                        failure(ForecastClientError.mappingError)
                    }
                    return
                }
                DispatchQueue.main.async {
                    completion(forecast)
                }
            } catch {
                DispatchQueue.main.async {
                    print("Forecast request error: getForecast error")
                    failure(error)
                }
            }
            
        }
        dataTask?.resume()
        
    }
    
    
    
}



