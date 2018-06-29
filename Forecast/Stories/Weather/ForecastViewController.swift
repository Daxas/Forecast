
import UIKit
import MapKit
//import Mapper

class ForecastViewController: UIViewController {
    
    let forecastClient = ForecastClient()
    
    @IBOutlet var windImage: UIImageView!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var humidityLabel: UILabel!
    @IBOutlet var pressureLabel: UILabel!
    @IBOutlet var windSpeedLabel: UILabel!
    @IBOutlet var summaryLabel: UILabel!
    @IBOutlet var iconImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        windImage.image = UIImage(named: "Icons")
        presentForecast()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
   
        private func presentForecast() {
        let location = CLLocationCoordinate2DMake(56.23, 43.411) 
        forecastClient.getForecast(for: location, completion: {forecast in
            self.tempLabel.text = forecast.temperature.toString(afterPoint: 0)
            self.summaryLabel.text = forecast.summary
            self.windSpeedLabel.text = forecast.windSpeed.toString(afterPoint: 0) + "m/c"
            self.pressureLabel.text = forecast.pressure.toString(afterPoint: 0) + "hPA"
            self.humidityLabel.text = forecast.humidity.toString(afterPoint: 0) + "%"
            self.iconImage.image = UIImage(named: forecast.icon)
        }, failure: {error in print(error)})
        
        
    }
    
    
    
}

