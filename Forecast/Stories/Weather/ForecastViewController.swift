
import UIKit
import MapKit

enum Constants: String {
    case hourlyCellIdentifier = "HourlyCell"
    case infoCellIdentifier = "infoCell"
    case dailyTableCell = "Daily"
}

enum DateFormatterType: String {
    case weekday = "EEEE"
    case hour = "hh:mm"
    case date = "dd MMM"
}

class ForecastViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var summaryLabel: UILabel!
    @IBOutlet var iconImage: UIImageView!
    
    let forecastClient = ForecastClient()
    var forecast = Forecast()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presentForecast(for: CLLocationCoordinate2DMake(56.23, 43.411))
        tableView.reloadData()
        collectionView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Private
    
    private func presentForecast(for location: CLLocationCoordinate2D) {
        forecastClient.getForecast(for: location, completion: {forecast in
            self.forecast = forecast
            self.show(forecast)
        }, failure: {error in print(error)})
    }
    
    private func show(_ forecast: Forecast){
        tempLabel.text = String(forecast.temperature.rounded()) //.toString(afterPoint: 0)
        summaryLabel.text = forecast.summary
        iconImage.image = UIImage(named: forecast.icon)
        tableView.reloadData()
        collectionView.reloadData()
    }
    
    private func getDateFromTimeInterval(time: Int, to type: DateFormatterType) -> String {
        let date = NSDate(timeIntervalSince1970: TimeInterval(time))
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = type.rawValue
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        return dateString
    }
    
}

extension ForecastViewController: UICollectionViewDataSource {
    // MARK: - CollectionView life cycle
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return forecast.hourlyData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.infoCellIdentifier.rawValue, for: indexPath) as! InfoCollectionViewCell
            configureInfoCell(cell, indexPath: indexPath)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.hourlyCellIdentifier.rawValue, for: indexPath) as! HourlyCollectionViewCell
            configureHourlyCell(cell, indexPath: indexPath)
            return cell
        }
        
    }
    
    private func configureHourlyCell(_ cell: HourlyCollectionViewCell, indexPath: IndexPath) {
        let item = forecast.hourlyData[indexPath.row - 1]
        cell.hourlyImage.image = UIImage(named: item.icon)
        cell.hourlyTempLabel.text = String(item.temperature.rounded())
        cell.timeLabel.text = getDateFromTimeInterval(time: item.time, to: .hour)
    }
    
    private func configureInfoCell(_ cell: InfoCollectionViewCell, indexPath: IndexPath) {
        cell.infoIcon.image = UIImage(named: "Icons")
        cell.windSpeedLabel.text = String(forecast.windSpeed.rounded())/*.toString(afterPoint: 0) */ + "m/c"
        cell.pressureLabel.text = String(forecast.pressure.rounded())/*.toString(afterPoint: 0)*/ + "hPA"
        cell.humidityLabel.text = String(forecast.humidity.rounded())/*.toString(afterPoint: 0)*/ + "%"
    }
}

extension ForecastViewController: UITableViewDataSource {
    // MARK: - TableView life cycle
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecast.dailyData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.dailyTableCell.rawValue, for: indexPath) as! DailyTableViewCell
        configureDailyTableCell(cell, indexPath: indexPath)
        return cell
    }
    
    private func configureDailyTableCell (_ cell: DailyTableViewCell, indexPath: IndexPath) {
        let item = forecast.dailyData[indexPath.row]
        cell.dateLabel.text = getDateFromTimeInterval(time: item.time, to: .date)
        cell.weekDayLabel.text = getDateFromTimeInterval(time: item.time, to: .weekday)
        cell.minTempLabel.text = String(item.minTemp.rounded())
        cell.maxTempLabel.text = String(item.maxTemp.rounded())
        cell.iconDaily.image = UIImage(named: (item.icon + "_"))
    }
    
}
