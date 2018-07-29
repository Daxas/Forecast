
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
    private let forecastAdapter = ForecastAdapter()
    private var spinnerActivity = MBProgressHUD()
    private var refresher: UIRefreshControl!
    
    private var wasOpen = false
    
    private lazy var dailyTablePresenter = DailyPresenter(with: self.dailyTableView)
    private lazy var hourlyCollectionPresenter = HourlyPresenter(with: self.collectionView)
    
    private let dateFormatter = DateFormatter()
    private let temperatureUtils = TemperatureUtils()
    
    // MARK: - Life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(forecastType(notification:)), name: Notification.Name("LocationDidChange"), object: nil)
        getForecast()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        updateLabels(with: forecastPoint)
    }
    
    // MARK: - Private
    
    private func configure() {
        tabBarItem.title = "Weather.title".localized()
        dailyTableView.allowsSelection = false
        collectionView.contentInset = UIEdgeInsetsMake(0, 16, 0, 16)
        configureRefresher()
    }
    
    private func configureRefresher() {
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh".localized())
        refresher.addTarget(self, action: #selector(ForecastViewController.refreshForecast), for: UIControlEvents.valueChanged)
        dailyTableView.addSubview(refresher)
    }
    
    // MARK: - Data
    
    private func getForecast() {
        startSpinner()
        wasOpen = UserDefaults.standard.bool(forKey: "WasOpen")
        guard wasOpen else {
            fetchCurrentForecast()
            wasOpen = true
            UserDefaults.standard.set(wasOpen, forKey: "WasOpen")
            return
        }
       forecastPoint = AppSettings().getSelectedCoordinates()
        guard forecastPoint != nil else {
            fetchCurrentForecast()
            return
        }
        fetchForecast()
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
            }, failure: {print($0)})
    }
    
    private func fetchForecast() {
        guard let point = forecastPoint else {
            return
        }
        forecastAdapter.getAddress(for: point, completion: { [weak self] in
            point.address = $0.address
            self?.forecastAdapter.getForecast(for: point, completion: { [weak self] in
                point.forecast = $0.forecast
                self?.handleForecastPoint(point)
                }, failure: {print($0)})
            }, failure: {print($0)})
    }
    
    private func handleForecastPoint(_ point: ForecastPoint) {
        forecastPoint = point
        stopSpinner()
        updateLabels(with: forecastPoint)
    }
    
    // MARK: - Private
    
    @objc private func refreshForecast() {
        getForecast()
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


