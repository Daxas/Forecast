import UIKit
import Foundation

enum FavoritesSections: Int {
    case current = 0
    case favorites
    
    var cellIdentifier: String {
        switch self {
        case .current:
            return CurrentLocationCell.reuseIdentifier()
        case .favorites:
            return FavoritesPointCell.reuseIdentifier()
        }
    }
    
    static var count: Int {
        return 2
    }
}

class FavoritesTablePresenter: NSObject {
    
    private let tableView: UITableView
    var favorites = [ForecastPoint]()
    var currentWeather: ForecastPoint?
   private let temperatureUtils = TemperatureUtils()
    
    func update(with currentForecast: ForecastPoint) {
        currentWeather = currentForecast
        tableView.reloadData()
    }
    
    private func configureCurrentLocationCell(_ cell: CurrentLocationCell) {
        cell.addressLabel.text = currentWeather?.address?.city
        cell.subAddressLabel.text = currentWeather?.address?.detail
        cell.temperatureLabel.text = temperatureUtils.getTemperatureFrom(number: (currentWeather?.forecast?.temperature)!)
        cell.weatherIcon.image = UIImage(named: (currentWeather?.forecast?.icon)!)
    }
    
    private func configureFavoritesCell(_ cell: FavoritesPointCell, indexPath: IndexPath) {
        
        let item = favorites[indexPath.row]
        cell.addressLabel.text = item.address?.city
        cell.subAddressLabel.text = item.address?.detail
        cell.temperatureLabel.text = temperatureUtils.getTemperatureFrom(number: (item.forecast?.temperature)!)
        cell.weatherIcon.image = UIImage(named: (item.forecast?.icon)!)
    }
  
    
   /* func update(with dailyForecast: Forecast) {
        forecast = dailyForecast
        tableView.reloadData()
    }
    
  
    */
    init(with tableView: UITableView) {
        self.tableView = tableView
        super.init()
        tableView.dataSource = self
        tableView.delegate = self
    }
}

// MARK: - TableView live cycle

extension FavoritesTablePresenter: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return section == 0 ? 1 : favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let section = FavoritesSections(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: section.cellIdentifier, for: indexPath)
        switch cell {
        case let cell as CurrentLocationCell:
            configureCurrentLocationCell(cell)
        case let cell as FavoritesPointCell:
          configureFavoritesCell(cell, indexPath: indexPath)
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       if indexPath.section == 0 {
            return CGFloat(100)
        } 
        
        return CGFloat(60)
    }
    
}
