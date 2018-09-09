import UIKit
import Foundation

class DailyPresenter: NSObject {
    
    private let tableView: UITableView
    private var forecast: Forecast?
    private let dateUtils = DateUtils()
    private let temperatureUtils = TemperatureUtils()
    
    func update(with dailyForecast: Forecast?) {
        forecast = dailyForecast
        tableView.reloadData()
    }
    
    private func configureDailyTableCell (_ cell: DailyTableViewCell, indexPath: IndexPath) {
        guard let forecast = forecast else {
            cell.dateLabel.text =  ""
            cell.weekDayLabel.text = ""
            cell.minTempLabel.text = ""
            cell.maxTempLabel.text = ""
            cell.iconDaily.image = nil
            return
        }
        let item = forecast.dailyData[indexPath.row]
        cell.dateLabel.text =  dateUtils.date(date: item.time)
        cell.weekDayLabel.text = dateUtils.weekDay(date: item.time)
        cell.minTempLabel.text = temperatureUtils.getTemperatureFrom(number: item.minTemp)
        cell.maxTempLabel.text = temperatureUtils.getTemperatureFrom(number: item.maxTemp)
        cell.iconDaily.image = UIImage(named: (item.icon + "_"))
    }
    
    init(with tableView: UITableView) {
        self.tableView = tableView
        super.init()
        tableView.dataSource = self
    }
}

// MARK: - TableView live cycle




extension DailyPresenter: UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let forecast = forecast else {
            return 0
        }
        return forecast.dailyData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.dailyTableCell, for: indexPath) as! DailyTableViewCell
        configureDailyTableCell(cell, indexPath: indexPath)
        return cell
    }
    
}
