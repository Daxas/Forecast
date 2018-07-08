
import UIKit
import CoreLocation

class ForecastViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
   
    @IBOutlet var streetLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var summaryLabel: UILabel!
    @IBOutlet var iconImage: UIImageView!
    
    let forecastClient = ForecastClient()
    var forecast: Forecast?
    private lazy var dailyTablePresenter = DailyPresenter(with: self.tableView)
    private lazy var hourlyCollectionPresenter = HourlyPresenter(with: self.collectionView)
    let dateFormatter = DateFormatter()
    var geoCoder = GeoCoder()
    var geoLocator = GeoLocator()
   
    var location: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // updateLabels(with: forecast, and: location)
        geoLocator.getLocation()
        print(location?.coordinate.latitude)
        
       
       
        updateLabels(with: forecast, and: location)
         //fetchForecast(for: location)
      
       // let location = CLLocation(latitude: 56.23, longitude: 43.411)
        //streetLabel.text = geoCoder.geoCode(for: location!, completion: {[weak self] address in
         //   self?.streetLabel.text = address}, failure: {print($0)})
       
        
    }
    
    func recevedLocation(location: CLLocation?){
        self.location = location
        
    }
   
    // MARK: - Private
    
    private func handleForecast(_ forecast: Forecast){
        self.forecast = forecast
        dailyTablePresenter.update(with: forecast)
        hourlyCollectionPresenter.update(with: forecast)
        show(forecast: forecast)
    }
    
    private func fetchForecast(for location: CLLocation?) {
        if let location = location {
        forecastClient.getForecast(for: location, completion: {[weak self] in
            //self?.activityIndicator.startAnimating()
            self?.updateLabels(with: $0, and: location)
           // self?.handleForecast($0)
            /*self?.activityIndicator.stopAnimating()*/} , failure: {print($0)})
      /*  adressLabel.text = geoCoder.geoCode(for: location, completion: {[weak self] address in
            self?.activityIndicator.startAnimating()
            self?.adressLabel.text = address
             self?.activityIndicator.stopAnimating()
            }, failure: {print($0)})*/
        }
    }
    
    private func show(forecast: Forecast){
        tempLabel.text = dateFormatter.temperature(temp: forecast.temperature)
        summaryLabel.text = forecast.summary
        iconImage.image = UIImage(named: forecast.icon)
    }
    
    private func updateLabels(with forecast: Forecast?, and location: CLLocation?) {
        if let location = location {
            cityLabel.text = geoCoder.geoCode(for: location, completion: {[weak self] address in
                self?.cityLabel.text = address
                }, failure: {print($0)})
            //streetLabel.text =
        } else {
            cityLabel.text = "-.-"
            streetLabel.text = "-"
            
            let statusMessage: String
            if let error = geoLocator.lastLocationError as? NSError {
                if error.domain == kCLErrorDomain &&
                    error.code == CLError.denied.rawValue {
                    statusMessage = "Location Services Disabled"
                } else {
                    statusMessage = "Error Getting Location"
                }
            } else if !CLLocationManager.locationServicesEnabled() {
                statusMessage = "Location Services Disabled"
            } else if geoLocator.updatingLocation {
                statusMessage = "Searching..."
            } else {
                statusMessage = "Tap 'Get My Location' to Start"
            }
            streetLabel.text = statusMessage
        }
        
        if let forecast = forecast {
            tempLabel.text = dateFormatter.temperature(temp: forecast.temperature)
            summaryLabel.text = forecast.summary
            iconImage.image = UIImage(named: forecast.icon)
            dailyTablePresenter.update(with: forecast)
            hourlyCollectionPresenter.update(with: forecast)
        } else {
            tempLabel.text = ""
            summaryLabel.text = ""
        }
       
    }
 
}

