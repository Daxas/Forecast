
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
    
    var forecastModel: ForecastModelProtocol!
    
    private var spinnerActivity = MBProgressHUD()
    private var refresher: UIRefreshControl!
    
    private lazy var dailyTablePresenter = DailyPresenter(with: self.dailyTableView)
    private lazy var hourlyCollectionPresenter = HourlyPresenter(with: self.collectionView)
    
    private let dateFormatter = DateFormatter()
    private let temperatureUtils = TemperatureUtils()
    
    init(forecastModel: ForecastModelProtocol) {
        self.forecastModel = forecastModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cleanWeatherLabels()
        forecastModel.viewWillAppear()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        forecastModel.viewDidLoad()
    }
    
    // MARK: - Private
    
    private func configure() {
        startSpinner()
        if let forecastModel = forecastModel as? ForecastModel {
            forecastModel.delegate = self
        }
        dailyTableView.allowsSelection = false
        collectionView.contentInset = UIEdgeInsetsMake(0, 16, 0, 16)
        configureRefresher()
        registerNibs()
    }
    
    private func registerNibs() {
        let dailyNib = UINib(nibName: "DailyTableViewCell", bundle: nil)
        dailyTableView.register(dailyNib, forCellReuseIdentifier: Identifier.dailyTableCell)
        let hourlyNib = UINib(nibName: "HourlyCollectionViewCell", bundle: nil)
        collectionView.register(hourlyNib, forCellWithReuseIdentifier: HourlyCollectionViewCell.reuseIdentifier())
        let infoNib = UINib(nibName: "InfoCollectionViewCell", bundle: nil)
        collectionView.register(infoNib, forCellWithReuseIdentifier: InfoCollectionViewCell.reuseIdentifier())
    }
    
    private func configureRefresher() {
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh".localized())
        refresher.addTarget(self, action: #selector(ForecastViewController.refreshForecast), for: UIControlEvents.valueChanged)
        dailyTableView.addSubview(refresher)
    }
    
    // MARK: - Private
    
    @objc private func refreshForecast() {
        forecastModel.viewWillAppear()
        refresher.endRefreshing()
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
    
    func stopSpinner() {
        spinnerActivity.hide(animated: true)
    }
    
    // MARK: - Override
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

// MARK: - ForecastModelDelegate

extension ForecastViewController: ForecastModelDelegate {
    
    func updateAddressLabels(with forecastPoint: ForecastPoint?) {
        if let address = forecastPoint?.address {
            cityLabel.text = address.city
            streetLabel.text = address.detail
        } else {
            cityLabel.text = "-.-"
            streetLabel.text = "-"
        }
    }
    
    func updateWeatherLabels(with forecastPoint: ForecastPoint?) {
        stopSpinner()
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
    
}


