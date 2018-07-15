
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
    
    var forecastPoint: ForecastPoint?
    var forecastAdapter = ForecastAdapter()
    
    private lazy var dailyTablePresenter = DailyPresenter(with: self.tableView)
    private lazy var hourlyCollectionPresenter = HourlyPresenter(with: self.collectionView)
    
    private let dateFormatter = DateFormatter()
    private let temperatureUtils = TemperatureUtils()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabels(with: forecastPoint)
        
        forecastAdapter.getForecastForCurrentPoint(completion: { (forecastPoint) in
            self.forecastPoint = forecastPoint
            self.updateLabels(with: forecastPoint)
        }, failure: {print($0)})
       
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    // MARK: - Private
    
    private func updateLabels(with forecastPoint: ForecastPoint?) {
        if let forecast = forecastPoint?.forecast {
            tempLabel.text = temperatureUtils.getTemperatureFrom(number: forecast.temperature) 
            summaryLabel.text = forecast.summary.localized()
            iconImage.image = UIImage(named: forecast.icon)
            dailyTablePresenter.update(with: forecast)
            hourlyCollectionPresenter.update(with: forecast)
        } else {
            tempLabel.text = ""
            summaryLabel.text = ""
        }
        if let address = forecastPoint?.address {
            cityLabel.text = address.city
            streetLabel.text = address.detail
        } else {
            cityLabel.text = "-.-"
            streetLabel.text = "-"
        }
    }
    
}


