
import UIKit
import MapKit
//import Mapper

class ForecastViewController: UIViewController {
    
    let forecastClient = ForecastClient()
    
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var humidityLabel: UILabel!
    @IBOutlet var pressureLabel: UILabel!
    @IBOutlet var windSpeedLabel: UILabel!
    @IBOutlet var summaryLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        
        let location = CLLocationCoordinate2DMake(56.23, 43.411) 
        forecastClient.getForecast(for: location, completion: {forecast in
            self.tempLabel.text = forecast.temperature.toString(afterPoint: 0)
            self.summaryLabel.text = forecast.summary
            self.windSpeedLabel.text = forecast.windSpeed.toString(afterPoint: 0)
            self.pressureLabel.text = forecast.pressure.toString(afterPoint: 0)
            self.humidityLabel.text = forecast.humidity.toString(afterPoint: 0)
        }, failure: {error in print(error)})
        
        
    }
    
    
    
}

