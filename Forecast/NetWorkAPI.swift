
import Foundation
import Mapper

class NetWorkAPI {
    
    func forecastURL(lat: Float, long: Float) -> URL {
        let urlString = String(format:
            "https://api.forecast.io/forecast/cfb098593c0899de76d374e96d68c8e3/56.23,43.411")
        /*let urlString = String(format:
         "https://api.forecast.io/forecast/cfb098593c0899de76d374e96d68c8e3/%@,%@", lat, long)*/
        
        let url = URL(string: urlString)
        return url!
    }
    
    func performForecastRequest(with url: URL) -> String? {
        do {
            return try String(contentsOf: url, encoding: .utf8)
        } catch {
            print("Download Error: \(error)")
            return nil
        }
    }
    
    func parse(json: String) ->  NSDictionary? {
        guard let data = json.data(using: .utf8, allowLossyConversion: false)
            else { return nil }
        do {
            return try JSONSerialization.jsonObject(
                with: data, options: []) as? NSDictionary
        } catch {
            print("JSON Error: \(error)")
            return nil
        }
    }
    
    
}

    

