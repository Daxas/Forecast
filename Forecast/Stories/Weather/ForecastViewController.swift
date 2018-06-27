
import UIKit
//import Mapper

class ForecastViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func buttonAction(_ sender: UIButton) {
        let forecastClient = ForecastClient(key: "", lat: 0, long: 0)
        forecastClient.sessionMenedger()
        
    }
    
    
   
}

