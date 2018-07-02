
import UIKit
import MapKit

enum Identifier: String {
    case hourlyCell = "HourlyCell"
    case infoCell = "infoCell"
    case dailyTableCell = "Daily"
}

enum DateFormatterType: String {
    case weekday = "EEEE"
    case hour = "hh:mm"
    case date = "dd MMM"
    
    var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = self.rawValue
        return formatter
    }
}

class ForecastViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var collectionView: UICollectionView!
    
    private lazy var dailyTablePresenter = DailyTablePresenter(with: self.tableView)
    private lazy var hourlyCollectionPresenter = HourlyCollectionPresenter(with: self.collectionView)
    
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var summaryLabel: UILabel!
    @IBOutlet var iconImage: UIImageView!
    
    let forecastClient = ForecastClient()
    var forecast: Forecast?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presentForecast(for: CLLocationCoordinate2DMake(56.23, 43.411))
        dailyTablePresenter.tableView.reloadData()
        hourlyCollectionPresenter.collectionView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Private
    
    private func presentForecast(for location: CLLocationCoordinate2D) {
        forecastClient.getForecast(for: location, completion: {[weak self] in
            self?.forecast = $0
            self?.dailyTablePresenter.update(with: $0)
            self?.hourlyCollectionPresenter.update(with: $0)
            self?.show($0)
        }, failure: {print($0)})
    }
    
    private func show(_ forecast: Forecast){
        tempLabel.text = forecast.temperature.rounded().toString(afterPoint: 0)
        summaryLabel.text = forecast.summary
        iconImage.image = UIImage(named: forecast.icon)
        dailyTablePresenter.tableView.reloadData()
        hourlyCollectionPresenter.collectionView.reloadData()
    }
    
    private func getDateFromTimeInterval(time: Date, to type: DateFormatterType) -> String {
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = type.rawValue
        let dateString = dayTimePeriodFormatter.string(from: time as Date)
        return dateString
    }
    
}

