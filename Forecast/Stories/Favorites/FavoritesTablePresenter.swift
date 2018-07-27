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
    
    var cellHeight: CGFloat {
        switch self {
        case .current:
            return CGFloat(100)
        case .favorites:
            return CGFloat(60)
        }
    }
    
    static var count: Int {
        return 2
    }
}
protocol FavoritesTablePresenterDelegate: class {
    func favoritesTablePresenterDelegate(_ sender: FavoritesTablePresenter, locationDidSelect point: ForecastPoint?)
    func favoritesTablePresenterDelegate(_ sender: FavoritesTablePresenter, favoritesDidChange: [ForecastPoint])
}

class FavoritesTablePresenter: NSObject {
    
    private let tableView: UITableView
    private var forecastAdapter = ForecastAdapter()
    private var favorites = [ForecastPoint]()
    
    private let temperatureUtils = TemperatureUtils()
    weak var delegate: FavoritesTablePresenterDelegate?
    
    func update(with favorites: [ForecastPoint]) {
        self.favorites = favorites
        tableView.reloadData()
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
            if point == self?.favorites[indexPath.row] {
                point.address = $0.address
                self?.updateCell(cell, with: point)
            } 
            }, failure: {print($0)})
        forecastAdapter.getForecast(for: point, completion: { [weak self] in
            if point == self?.favorites[indexPath.row] {
                point.forecast = $0.forecast
                self?.updateCell(cell, with: point)
            }
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
        // guard let
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
        guard let section = FavoritesSections(rawValue: indexPath.section) else {
            return tableView.estimatedRowHeight
        }
        return section.cellHeight
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
        tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        delegate?.favoritesTablePresenterDelegate(self, favoritesDidChange: favorites)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedLocation = indexPath.section == 0 ? nil : favorites[indexPath.row]
        delegate?.favoritesTablePresenterDelegate(self, locationDidSelect: selectedLocation)
    }
    
    
    
}
