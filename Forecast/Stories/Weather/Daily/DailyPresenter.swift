import UIKit
import Foundation

class DailyPresenter: NSObject {
    
    private let tableView: UITableView
    private var forecast: Forecast?
    private let dateFormatter = DateFormatter()
    
    func update(with dailyForecast: Forecast) {
        forecast = dailyForecast
        tableView.reloadData()
    }
    
    private func configureDailyTableCell (_ cell: DailyTableViewCell, indexPath: IndexPath) {
        guard let forecast = forecast else {
            return
        }
        let item = forecast.dailyData[indexPath.row]
        cell.dateLabel.text =  dateFormatter.date(date: item.time)
        cell.weekDayLabel.text = dateFormatter.weekDay(date: item.time)
        cell.minTempLabel.text = dateFormatter.temperature(temp: item.minTemp)
        cell.maxTempLabel.text = dateFormatter.temperature(temp: item.maxTemp)
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
