
import UIKit
import CoreLocation

class ForecastViewController: UIViewController, GeoLocatorDelegate {
    
    
    
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
    var location: CLLocation?
    
    private lazy var dailyTablePresenter = DailyPresenter(with: self.tableView)
    private lazy var hourlyCollectionPresenter = HourlyPresenter(with: self.collectionView)
    let dateFormatter = DateFormatter()
    
    var geoCoder = GeoCoder()
    var geoLocator = GeoLocator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        geoLocator.delegate = self
        geoLocator.getLocation()
        updateLabels(with: forecast, and: location)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func geoLocatorGetLocation(geoLocator: GeoLocator, receved location: CLLocation) {
        self.location = location
        fetchForecast(for: location)
    }
    
    
    // MARK: - Private
    
    private func fetchForecast(for location: CLLocation?) {
        if let location = location {
            activityIndicator.startAnimating()
            forecastClient.getForecast(for: location, completion: {[weak self] in
                self?.forecast = $0
                self?.updateLabels(with: $0, and: location)
                self?.activityIndicator.stopAnimating()} , failure: {print($0)})
        }
    }
    
    private func updateLabels(with forecast: Forecast?, and location: CLLocation?) {
        activityIndicator.startAnimating()
        if let location = location {
            geoCoder.geoCode(for: location, completion: {[weak self] address in
                self?.cityLabel.text = address[0]
                self?.streetLabel.text = address[1]
                
                }, failure: {print($0)})
        } else {
            cityLabel.text = "-.-"
            streetLabel.text = "-"
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
        activityIndicator.stopAnimating()
    }
    
}

