
import UIKit
import CoreLocation
import MBProgressHUD

class ForecastViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var headerView: UIView!
    
    @IBOutlet var streetLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var summaryLabel: UILabel!
    @IBOutlet var iconImage: UIImageView!
    
    var forecastPoint: ForecastPoint?
    var forecastAdapter = ForecastAdapter()
    var spinnerActivity = MBProgressHUD()
    var refresher: UIRefreshControl!
    
    private lazy var dailyTablePresenter = DailyPresenter(with: self.tableView)
    private lazy var hourlyCollectionPresenter = HourlyPresenter(with: self.collectionView)
    
    private let dateFormatter = DateFormatter()
    private let temperatureUtils = TemperatureUtils()
    
    // MARK: - Life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startSpinner()
        fetchCurrentForecast()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        updateLabels(with: forecastPoint)
        
        
    }
    
    private func configure() {
        tabBarItem.title = "Weather.title".localized()
        collectionView.contentInset = UIEdgeInsetsMake(0, 16, 0, 16)
        configureRefresher()
    }
    
    private func configureRefresher() {
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh".localized())
        refresher.addTarget(self, action: #selector(ForecastViewController.refreshForecast), for: UIControlEvents.valueChanged)
        tableView.addSubview(refresher)
        
    }
    
    // MARK: - Data
    
    
    private func startSpinner() {
        spinnerActivity = MBProgressHUD.showAdded(to: self.view, animated: true)
        spinnerActivity.label.text = "Loading".localized()
        spinnerActivity.detailsLabel.text = "Please Wait!".localized()
        spinnerActivity.isUserInteractionEnabled = false
    }
    
    private func stopSpinner() {
        spinnerActivity.hide(animated: true)
    }
    
    private func fetchCurrentForecast() {
        forecastAdapter.getForecastForCurrentPoint(completion: { [weak self] in
            self?.handleForecastPoint($0)
            }, failure: {print($0)})
    }
    
    private func handleForecastPoint(_ forecastPoint: ForecastPoint) {
        self.forecastPoint = forecastPoint
        self.stopSpinner()
        self.updateLabels(with: self.forecastPoint)
    }
    
    // MARK: - Private
    
    @objc private func refreshForecast() {
        fetchCurrentForecast()
        refresher.endRefreshing()
    }
    
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
    
    // MARK: - Override
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}


