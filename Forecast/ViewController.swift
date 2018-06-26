
import UIKit
import Mapper

class ViewController: UIViewController {

   //var currently: [String: Any]?
   //var hourly: [String: Any]?
    //var daily: [String: Any]?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    
    
   
    
    @IBAction func buttonAction(_ sender: UIButton) {
        
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
                        print("summary", forecast?.summary)
                        }
                }
            }
        })
        dataTask.resume()
        
        
        
    }
    
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
    
    func parse(json: String) ->  NSDictionary? /*[String: Any]?*/ {
        guard let data = json.data(using: .utf8, allowLossyConversion: false)
            else { return nil }
        do {
            return try JSONSerialization.jsonObject(
                with: data, options: []) as? NSDictionary// [String: Any]
        } catch {
            print("JSON Error: \(error)")
            return nil
        }
    }
   
}

