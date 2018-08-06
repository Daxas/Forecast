
import UIKit
import CoreLocation
import MBProgressHUD

class ForecastViewController: UIViewController {
    
    @IBOutlet var dailyTableView: UITableView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var streetLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var summaryLabel: UILabel!
    @IBOutlet var iconImage: UIImageView!
    
    private var forecastPoint: ForecastPoint?
    //private let store = FavoritesStore()
    
    private let forecastAdapter = ForecastAdapter()
    private var spinnerActivity = MBProgressHUD()
    private var refresher: UIRefreshControl!
    
    private lazy var dailyTablePresenter = DailyPresenter(with: self.dailyTableView)
    private lazy var hourlyCollectionPresenter = HourlyPresenter(with: self.collectionView)
    
    private let dateFormatter = DateFormatter()
    private let temperatureUtils = TemperatureUtils()
    
    // MARK: - Life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateAddressLabels(with: forecastPoint)
        cleanWeatherLabels()
        getForecast()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(forecastType(notification:)), name: .locationDidChange , object: nil)
        configure()
    }
    
    // MARK: - Private
    
    private func configure() {
        startSpinner()
        tabBarItem.title = "Weather.title".localized()
        dailyTableView.allowsSelection = false
        collectionView.contentInset = UIEdgeInsetsMake(0, 16, 0, 16)
        configureRefresher()
        
        guard let coordinates = AppSettings().getSelectedCoordinates() else {
            forecastPoint = nil
            return
        }
        forecastPoint = ForecastPoint(with: coordinates)
        
        forecastAdapter.getAddress(for: forecastPoint!, completion: { [weak self] in
            self?.forecastPoint?.address = $0.address
            self?.updateAddressLabels(with: self?.forecastPoint)
            }, failure: {print($0)})
        
    }
    
    private func configureRefresher() {
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh".localized())
        refresher.addTarget(self, action: #selector(ForecastViewController.refreshForecast), for: UIControlEvents.valueChanged)
        dailyTableView.addSubview(refresher)
    }
    
    // MARK: - Data
    
    private func getForecast() {
        guard forecastPoint == nil else {
            fetchForecast()
            return
        }
        fetchCurrentForecast()
    }
    
    @objc private func forecastType(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        guard let selectedLocation = userInfo["favorLocation"] as? ForecastPoint else {
            forecastPoint = nil
            return
        }
        forecastPoint = selectedLocation
    }
    
    private func fetchCurrentForecast() {
        forecastAdapter.getForecastForCurrentPoint(completion: { [weak self] in
            self?.handleForecastPoint($0)
            self?.updateAddressLabels(with: $0)
            }, failure: {print($0)})
    }
    
    private func fetchForecast() {
        guard let point = forecastPoint else {
            return
        }
        forecastAdapter.getForecast(for: point, completion: { [weak self] in
            point.forecast = $0.forecast
            self?.handleForecastPoint(point)
            }, failure: {print($0)})
    }
    
    private func handleForecastPoint(_ point: ForecastPoint) {
        stopSpinner()
        updateWeatherLabels(with: point)
    }
    
    // MARK: - Private
    
    @objc private func refreshForecast() {
        getForecast()
        refresher.endRefreshing()
    }
    
    private func updateAddressLabels(with forecastPoint: ForecastPoint?) {
        if let address = forecastPoint?.address {
            cityLabel.text = address.city
            streetLabel.text = address.detail
        } else {
            cityLabel.text = "-.-"
            streetLabel.text = "-"
        }
    }
    
    private func updateWeatherLabels(with forecastPoint: ForecastPoint?) {
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
    }
    
    private func cleanWeatherLabels() {
        tempLabel.text = ""
        summaryLabel.text = "-"
        iconImage.image = nil
        dailyTablePresenter.update(with: nil)
        hourlyCollectionPresenter.update(with: nil)
    }
    // MARK: - ActivitySpinner
    
    private func startSpinner() {
        spinnerActivity = MBProgressHUD.showAdded(to: self.view, animated: true)
        spinnerActivity.label.text = "Loading".localized()
        spinnerActivity.detailsLabel.text = "Please Wait!".localized()
        spinnerActivity.isUserInteractionEnabled = false
    }
    
    private func stopSpinner() {
        spinnerActivity.hide(animated: true)
    }
    
    // MARK: - Override
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}


