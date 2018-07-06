
import UIKit
import CoreLocation

class ForecastViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var adressLabel: UILabel!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var summaryLabel: UILabel!
    @IBOutlet var iconImage: UIImageView!
    
    let forecastClient = ForecastClient()
    var forecast: Forecast?
    private lazy var dailyTablePresenter = DailyPresenter(with: self.tableView)
    private lazy var hourlyCollectionPresenter = HourlyPresenter(with: self.collectionView)
    let dateFormatter = DateFormatter()
    var geoCoder = GeoCoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let location = CLLocation(latitude: 56.23, longitude: 43.411)
        adressLabel.text = geoCoder.geoCode(for: location, completion: {[weak self] address in
            
            self?.adressLabel.text = address}, failure: {print($0)})
        fetchForecast(for: location)
    }
    
    // MARK: - Private
    
    private func handleForecast(_ forecast: Forecast){
        self.forecast = forecast
        dailyTablePresenter.update(with: forecast)
        hourlyCollectionPresenter.update(with: forecast)
        show(forecast: forecast)
    }
    
    private func fetchForecast(for location: CLLocation) {
        forecastClient.getForecast(for: location, completion: {[weak self] in
            self?.activityIndicator.startAnimating()
            self?.handleForecast($0)
            self?.activityIndicator.stopAnimating()} , failure: {print($0)})
        adressLabel.text = geoCoder.geoCode(for: location, completion: {[weak self] address in
            self?.activityIndicator.startAnimating()
            self?.adressLabel.text = address
             self?.activityIndicator.stopAnimating()
            }, failure: {print($0)})
    }
    
    private func show(forecast: Forecast){
        tempLabel.text = dateFormatter.temperature(temp: forecast.temperature)
        summaryLabel.text = forecast.summary
        iconImage.image = UIImage(named: forecast.icon)
    }
    
    
    
}

