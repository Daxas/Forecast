import UIKit
import Foundation
import CoreLocation

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
    
    func update(favorites: [ForecastPoint]) {
        self.favorites = favorites
        tableView.reloadData()
    }
    
    // MARK: - Configure cells
    
    private func configureCurrentLocationCell(_ cell: CurrentLocationCell) {
        guard let currentWeather = currentWeather else {
            return
        }
        guard let address = currentWeather.address else {
            cell.addressLabel.text = "-"
            cell.subAddressLabel.text = "-.-"
            return
        }
        cell.addressLabel.text = address.city
        cell.subAddressLabel.text = address.detail
        
        guard let forecast = currentWeather.forecast else {
            cell.temperatureLabel.text = "--"
            return
        }
        cell.temperatureLabel.text = temperatureUtils.getTemperatureFrom(number: forecast.temperature)
        cell.weatherIcon.image = UIImage(named: forecast.icon)
    }
    
    private func configureFavoritesCell(_ cell: FavoritesPointCell, indexPath: IndexPath) {
        let item = favorites[indexPath.row]
        if let forecast = item.forecast {
            cell.temperatureLabel.text = temperatureUtils.getTemperatureFrom(number: forecast.temperature)
            cell.weatherIcon.image = UIImage(named: forecast.icon + "_")
        } else {
            cell.temperatureLabel.text = "--"
        }
        
        if let address = item.address{
            cell.addressLabel.text = address.city
            cell.subAddressLabel.text = address.detail
        } else {
            cell.addressLabel.text = "-"
            cell.subAddressLabel.text = "-.-"
        }
    }
    
    init(with tableView: UITableView) {
        self.tableView = tableView
        super.init()
        tableView.dataSource = self
        tableView.delegate = self
    }
}



extension FavoritesTablePresenter: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - TableView live cycle
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return FavoritesSections.count
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section != 0 {
            return "Favorites".localized()
        }
        return ""
    }
    
    // MARK: - Editing tableView
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        favorites.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let favorLocation =  indexPath.section == 0 ? nil : ["favorLocation": favorites[indexPath.row].location]
        NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil, userInfo: favorLocation)
    }
}
