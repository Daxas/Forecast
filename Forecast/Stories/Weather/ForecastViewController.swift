
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
    
    var isCurrentLocation = true
    var favorLocation: CLLocation?
   
   //let gradient = GradientView()
    
    private lazy var dailyTablePresenter = DailyPresenter(with: self.tableView)
    private lazy var hourlyCollectionPresenter = HourlyPresenter(with: self.collectionView)
    
    private let dateFormatter = DateFormatter()
    private let temperatureUtils = TemperatureUtils()
    
    // MARK: - Life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        startSpinner()
        if isCurrentLocation {
            fetchCurrentForecast()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(fetchForecast(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)
        configure()
        updateLabels(with: forecastPoint)
        
    }
    
    private func configure() {
       // headerView.insertSubview(GradientView., belowSubview: headerView)
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
    
    
    
    
    private func startSpinner() {
        spinnerActivity = MBProgressHUD.showAdded(to: self.view, animated: true)
        spinnerActivity.label.text = "Loading".localized()
        spinnerActivity.detailsLabel.text = "Please Wait!".localized()
        spinnerActivity.isUserInteractionEnabled = false
    }
    
    private func stopSpinner() {
        spinnerActivity.hide(animated: true)
    }
    
    // MARK: - Data
    
    private func fetchCurrentForecast() {
       forecastAdapter.getForecastForCurrentPoint(completion: { [weak self] in
            self?.handleForecastPoint($0)
            }, failure: {print($0)})
    }
    
    @objc private func fetchForecast(notification: NSNotification) {
        guard let location = notification.userInfo?["favorLocation"]  as? CLLocation else {
            return
        }
        isCurrentLocation = false
        let forecastPoint = ForecastPoint(with: location)
        forecastAdapter.getAddress(for: forecastPoint, completion: { (point) in
            forecastPoint.address = point.address
            self.forecastAdapter.getForecast(for: forecastPoint, completion: { (point) in
                forecastPoint.forecast = point.forecast
                self.handleForecastPoint(forecastPoint)
            }, failure: {print($0)})
        }, failure: {print($0)})
    }
    
    private func handleForecastPoint(_ forecastPoint: ForecastPoint) {
       self.stopSpinner()
        self.forecastPoint = forecastPoint
        self.updateLabels(with: self.forecastPoint)
    }
    
    // MARK: - Private
    
    @objc private func refreshForecast() {
        if isCurrentLocation {
            fetchCurrentForecast()
        } 
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


