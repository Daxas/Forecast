import UIKit
import Foundation
import CoreLocation

enum FavoritesSections: Int {
    case current = 0
    case favorites
    
    var cellIdentifier: String {
        switch self {
        case .current:
            return "CurrentLocationCell"
        case .favorites:
            return "FavoritesPointCell"
        }
    }
    
    static var count: Int {
        return 2
    }
}

class FavoritesTablePresenter: NSObject {
    
    private let tableView: UITableView
    private let store = Store()
    private var forecastAdapter = ForecastAdapter()
    
    private var firstTime = true
    
    private var favorites = [ForecastPoint]()
    
    private let temperatureUtils = TemperatureUtils()
    
    
    func makeFavorites(locations: [CLLocation]) {
        if firstTime {
            for location in locations {
                let point = ForecastPoint(with: location)
                favorites.append(point)
            }
            store.save(favorites: favorites)
        } else {
            favorites = store.load()
        }
        tableView.reloadData()
        firstTime = false
        
    }
    
    // MARK: - Configure cells
    
    private func configureCurrentLocationCell(_ cell: FavoritesPointCell) {
        forecastAdapter.getForecastForCurrentPoint(completion: {[weak self] in
            self?.updateCell(cell, with: $0)
            } , failure: {print($0)} )
    }
    
    private func configureFavoritesCell(_ cell: FavoritesPointCell, indexPath: IndexPath) {
        let point = favorites[indexPath.row]
        forecastAdapter.getAddress(for: point, completion: { [weak self] in
            point.address = $0.address
            self?.updateCell(cell, with: point)
            }, failure: {print($0)})
        forecastAdapter.getForecast(for: point, completion: { [weak self] in
            point.forecast = $0.forecast
            self?.updateCell(cell, with: point)
            }, failure: {print($0)})
    }
    
    private func updateCell(_ cell: FavoritesPointCell, with forecastPoint: ForecastPoint) {
        if let forecast = forecastPoint.forecast {
            cell.temperatureLabel.text = temperatureUtils.getTemperatureFrom(number: forecast.temperature)
            cell.weatherIcon.image = UIImage(named: forecast.icon + "_")
        } else {
            cell.temperatureLabel.text = "--"
        }
        
        if let address = forecastPoint.address{
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
        return tableView.dequeueReusableCell(withIdentifier: section.cellIdentifier, for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let favorCell = cell as! FavoritesPointCell
        if indexPath.section == 0 {
            configureCurrentLocationCell(favorCell)
        } else {
            configureFavoritesCell(favorCell, indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("didEndDisplaying cell " + "\(indexPath.row)")
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
        store.save(favorites: favorites)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        store.save(favorites: favorites)
        let selectedIndex = indexPath.section == 0 ? nil : indexPath.row
        NotificationCenter.default.post(name: Notification.Name("SelectedLocation"), object: nil, userInfo: ["favorLocation": selectedIndex as Any])
        UserDefaults.standard.set(selectedIndex, forKey: "SelectedLocationIndex")
    }
    
    
    
}
