
import Foundation
import Mapper

class ForecastClient {
    var key: String
    var lat: Double
    var long: Double
    
    init(key: String, lat: Double, long: Double) {
        self.key = key
        self.lat = lat
        self.long = long
    }
    
    private func forecastURL(lat: Double, long: Double) -> URL {
        let urlString = String(format:
            "https://api.forecast.io/forecast/cfb098593c0899de76d374e96d68c8e3/56.23,43.411")
        /*let urlString = String(format:
         "https://api.forecast.io/forecast/cfb098593c0899de76d374e96d68c8e3/%@,%@", lat, long)*/
        
        let url = URL(string: urlString)
        return url!
    }
    
    private func performForecastRequest(with url: URL) -> String? {
        do {
            return try String(contentsOf: url, encoding: .utf8)
        } catch {
            print("Download Error: \(error)")
            return nil
        }
    }
    
    private func parse(json: String) ->  NSDictionary? {
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
    
    func sessionMenedger() {
        let url = forecastURL(lat: 0, long: 0)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url, completionHandler: {
            data, response, error in
            if let error = error {
                print("Failure! \(error)")
            } else {
                let queue = DispatchQueue.global()
                queue.async {
                    if let jsonString = self.performForecastRequest(with: url),
                        let jsonDictionary = self.parse(json: jsonString)  {
                        let forecast = Forecast.from(jsonDictionary)
                        for dataPoint in (forecast?.dailyData)! {
                            print(dataPoint.icon)
                        }
                        print("summary", forecast?.summary)
                        
                    }
                }
            }
        })
        dataTask.resume()
    }
    
}

    

