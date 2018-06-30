
import UIKit
import MapKit
//import Mapper

let hourlyCellIdentifier = "HourlyCell"
let infoCellIdentifier = "infoCell"

class ForecastViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var collectionView: UICollectionView!
    
    let forecastClient = ForecastClient()
    
    
    var forecast = Forecast()
    
   
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var summaryLabel: UILabel!
    @IBOutlet var iconImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        presentForecast()
        tableView.reloadData()
        collectionView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
   
        private func presentForecast() {
        let location = CLLocationCoordinate2DMake(56.23, 43.411) 
        forecastClient.getForecast(for: location, completion: {forecast in
            self.forecast = forecast
            //
            self.tempLabel.text = String(forecast.temperature) //.toString(afterPoint: 0)
            self.summaryLabel.text = forecast.summary
            //
            self.iconImage.image = UIImage(named: forecast.icon)
            
        }, failure: {error in print(error)})
        
        
    }
    
}

    extension ForecastViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return forecast.hourlyData.count
        }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: infoCellIdentifier, for: indexPath) as! InfoCollectionViewCell
            configureInfoCell(cell, indexPath: indexPath)
             return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: hourlyCellIdentifier, for: indexPath) as! HourlyCollectionViewCell
            configureHourlyCell(cell, indexPath: indexPath)
             return cell
        }
       
    }
    
        private func configureHourlyCell(_ cell: HourlyCollectionViewCell, indexPath: IndexPath) {
            let item = forecast.hourlyData[indexPath.row - 1]
            cell.hourlyImage.image = UIImage(named: item.icon)
            //
            cell.hourlyTempLabel.text = String(item.temperature)
            //
            cell.timeLabel.text = String(item.time)
        }
        
        private func configureInfoCell(_ cell: InfoCollectionViewCell, indexPath: IndexPath) {
            cell.infoIcon.image = UIImage(named: "Icons")
            cell.windSpeedLabel.text = String(forecast.windSpeed)/*.toString(afterPoint: 0) */ + "m/c"
            cell.pressureLabel.text = String(forecast.pressure)/*.toString(afterPoint: 0)*/ + "hPA"
            cell.humidityLabel.text = String(forecast.humidity)/*.toString(afterPoint: 0)*/ + "%"
        }
}

extension ForecastViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecast.dailyData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Daily", for: indexPath) as! DailyTableViewCell
        configureDailyTableCell(cell, indexPath: indexPath)
        return cell
    }
    
    private func configureDailyTableCell (_ cell: DailyTableViewCell, indexPath: IndexPath) {
        let item = forecast.dailyData[indexPath.row]
    cell.weekDayLabel.text = String(item.time)
   // cell.dateLabel.text
    cell.minTempLabel.text = String(item.minTemp)
    cell.maxTempLabel.text = String(item.maxTemp)
        cell.iconDaily.image = UIImage(named: (item.icon + "_"))
    }
    
}
