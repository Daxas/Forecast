import UIKit
import Foundation

class DailyTablePresenter: NSObject, UITableViewDataSource {
 
    let tableView: UITableView
     var forecast: Forecast?
    
    func update(with dailyForecast: Forecast) {
        forecast = dailyForecast
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let forecast = forecast else {
           return 0
        }
        return (forecast.dailyData?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.dailyTableCell.rawValue, for: indexPath) as! DailyTableViewCell
        configureDailyTableCell(cell, indexPath: indexPath)
        return cell
    }
    
    private func configureDailyTableCell (_ cell: DailyTableViewCell, indexPath: IndexPath) {
        guard let forecast = forecast else {
            return
        }
        let item = forecast.dailyData![indexPath.row]
        //cell.dateLabel.text = getDateFromTimeInterval(time: item.time, to: .date)
        //cell.weekDayLabel.text = getDateFromTimeInterval(time: item.time, to: .weekday)
        let minTemp = item.minTemp.rounded().toString(afterPoint: 0)
        cell.minTempLabel.text = item.minTemp > 0 ? "+" + minTemp : minTemp
        let maxTemp = item.maxTemp.rounded().toString(afterPoint: 0)
        cell.maxTempLabel.text = item.maxTemp > 0 ? "+" + maxTemp : maxTemp
        cell.iconDaily.image = UIImage(named: (item.icon + "_"))
    }
    
    init(with tableView: UITableView) {
       self.tableView = tableView
        super.init()
        tableView.dataSource = self
    }
}

/*class ForecastDailyDataViewModel {
    
    let item: ForecastDailyData
    
    var date: String {
        return DateFormatterFactory
    }
    var minTemp: String {
        return item.minTemp.rounded().toString(afterPoint: 0)
    }
    var maxTemp: String {
        return item.maxTemp.rounded().toString(afterPoint: 0)
    }
    var icon: UIImage {
        return UIImage(named: (item.icon + "_"))
    }
    
    init(with data: ForecastDailyData) {
        self.item = data
    }
    
}*/
