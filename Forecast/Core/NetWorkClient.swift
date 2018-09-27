
import MapKit

enum NetWorkClientError: Error {
    case urlError
    case responceError
    case mappingError
    case dataError
    case dataTaskError
}

protocol NetWorkClientProtocol: class {
    func getForecast(for location: CLLocation,
                     completion: @escaping (Forecast) -> Void,
                     failure: @escaping (Error) -> Void)
}

class NetWorkClient: NetWorkClientProtocol {
    
    struct Configuration {
        static var apiKey   = "cfb098593c0899de76d374e96d68c8e3"
        static let baseURL  = "https://api.forecast.io/forecast/"
        static let language = "en".localized()
    }
    
    func getForecast(for location: CLLocation,
                     completion: @escaping (Forecast) -> Void, 
        do {
            let url = try configureURL(for: location)
            let dataTask = request(with: url) { (data) in
                let forecast = try self.parsing(data: data)
                DispatchQueue.main.async {
                    completion(forecast)
                }
            }
        } catch let error as NetWorkClientError {
            handle(error: error)
        } catch {
            print("Something went wrong")
        }
    }
    
    // MARK: - Private
    
    private func configureURL(for location: CLLocation) throws -> URL {
        let lat = String(format: "%.3f", location.coordinate.latitude)
        let long = String(format: "%.3f", location.coordinate.longitude)
        let baseURL = Configuration.baseURL + Configuration.apiKey
        let path = baseURL + "/" + lat + "," + long + "?units=si" + "&lang=" + Configuration.language
        guard let url = URL(string: path) else {
            throw NetWorkClientError.urlError
        }
        return url
    }
    
    private func request(with url: URL, completion: @escaping (Data) throws -> Void) -> URLSessionDataTask? {
        let urlSession = URLSession.shared
        var dataTask: URLSessionDataTask?
        dataTask?.cancel()
        dataTask = urlSession.dataTask(with: url, completionHandler: { (data, response, error) in
            do {
                let dataForParsing = try self.handleResponse(data: data, response: response, error: error)
                try! completion(dataForParsing)
            } catch {
                
            }
            
        })
        dataTask?.resume()
        return dataTask
    }
    
    private func handleResponse(data: Data?, response: URLResponse?, error: Error?) throws -> Data {
        guard error == nil else {
            throw NetWorkClientError.dataError
        }
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetWorkClientError.responceError
        }
        guard let data = data else {
            throw NetWorkClientError.dataError
        }
        return data
    }
    
    private func parsing(data: Data) throws -> Forecast {
        let decoder = JSONDecoder()
        let forecast = try! decoder.decode(Forecast.self, from: data)
        return forecast
    }
    
    private func handle(error: NetWorkClientError) {
        let prefix = "Forecast request error:"
        switch error {
        case .dataError:
            print("\(prefix) no data")
        case .mappingError:
            print("\(prefix) can't convert JSON")
        case .responceError:
            print("\(prefix) no httpResponse")
        case .urlError:
            print("\(prefix) url error")
        case .dataTaskError:
            print("\(prefix) error dataTask")
        }
    }
    
}

