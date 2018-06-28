
import UIKit
import MapKit
//import Mapper

class ForecastViewController: UIViewController {

    let forecastClient = ForecastClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func buttonAction(_ sender: UIButton) {
        
        let location = CLLocationCoordinate2DMake(56.23, 43.411) 
        forecastClient.getForecast(for: location, completion: {forecast in print(forecast.summary)  }, failure: {error in print(error)})
        
         
    }
    
    
   
}

