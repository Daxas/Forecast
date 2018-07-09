
import UIKit
import CoreLocation

class ForecastViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet var streetLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var summaryLabel: UILabel!
    @IBOutlet var iconImage: UIImageView!
    
    var forecast: Forecast?
    var address: [String]?
    
    var forecastAdapter = ForecastAdapter()
    var geoLocator = GeoLocator()
    private lazy var dailyTablePresenter = DailyPresenter(with: self.tableView)
    private lazy var hourlyCollectionPresenter = HourlyPresenter(with: self.collectionView)
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabels(with: forecast, and: address)
        geoLocator.delegate = forecastAdapter
        forecastAdapter.delegate = self
        geoLocator.getLocation()
        updateLabels(with: forecast, and: address)
        //activityIndicator.stopAnimating()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    // MARK: - Private
    
    private func updateLabels(with forecast: Forecast?, and address: [String]?) {
        if let forecast = forecast {
            //activityIndicator.stopAnimating()
            tempLabel.text = dateFormatter.temperature(temp: forecast.temperature)
            summaryLabel.text = forecast.summary
            iconImage.image = UIImage(named: forecast.icon)
            dailyTablePresenter.update(with: forecast)
            hourlyCollectionPresenter.update(with: forecast)
        } else {
            //activityIndicator.startAnimating()
            tempLabel.text = ""
            summaryLabel.text = ""
        }
        if let address = address {
            //activityIndicator.stopAnimating()
            cityLabel.text = address[0]
            streetLabel.text = address[1]
        } else {
            //activityIndicator.startAnimating()
            cityLabel.text = "-.-"
            streetLabel.text = "-"
        }
        
    }
    
}

// MARK: - Delegate

extension ForecastViewController: ForecastAdapterDelegate {
    
    func forecastAdapterDelegate(_ forecastAdapter: ForecastAdapter, didReceved location: [String]) {
        updateLabels(with: forecast, and: location)
    }
    
    func forecastAdapterDelegate(_ forecastAdapter: ForecastAdapter, didReceved forecast: Forecast) {
        updateLabels(with: forecast, and: address)
    }
}
