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
    func favoritesPresenterDelegate(didSelect point: ForecastPoint?)
    func favoritesPresenterDelegate(favoritesDidChange favorites: [ForecastPoint])
}

class FavoritesTablePresenter: NSObject {
    
    private let tableView: UITableView
    private var favorites = [ForecastPoint]()
    
    weak var delegate: FavoritesTablePresenterDelegate?
    
    // MARK: - Public
    
    func update(with favorites: [ForecastPoint]) {
        self.favorites = favorites
        tableView.reloadData()
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
            return section == FavoritesSections.favorites.rawValue ? favorites.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let section = FavoritesSections(rawValue: indexPath.section) else {
                return UITableViewCell()
            }
            return tableView.dequeueReusableCell(withIdentifier: section.cellIdentifier, for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let favorCell = cell as? FavoritesPointCell else {
            return
        }
        if  indexPath.section == FavoritesSections.current.rawValue {
            favorCell.currentLocationLabel.text = "Current location".localized()
            favorCell.configureCurrentLocationCell()
        } else {
            favorCell.configureFavoritesCell(with: favorites[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = FavoritesSections(rawValue: indexPath.section) else {
            return tableView.estimatedRowHeight
        }
        return section.cellHeight
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == FavoritesSections.current.rawValue {
            return false
        }
        return true
    }
    
    // MARK: - TableView header and footer
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerNib = UINib.init(nibName: "FavoritesHeaderView", bundle: Bundle.main)
        tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: "FavoritesHeaderView")
        guard section == FavoritesSections.favorites.rawValue else {
            return nil
        }
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "FavoritesHeaderView") as! FavoritesHeaderView
        headerView.favoritesLabel.text = "Favorites".localized()
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerNib = UINib.init(nibName: "FavoritesFooterView", bundle: Bundle.main)
        tableView.register(footerNib, forHeaderFooterViewReuseIdentifier: "FavoritesFooterView")
        guard section == FavoritesSections.favorites.rawValue else {
            return nil
        }
        let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "FavoritesFooterView") as! FavoritesFooterView
        footerView.infoLabel.text = "Add a city to yourFavorites and you can quickly see what the wheather is like there.\nTo do this, search for the place.".localized()
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == FavoritesSections.favorites.rawValue {
            return FavoritesSections.favorites.cellHeight
        }
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == FavoritesSections.favorites.rawValue {
            return FavoritesSections.current.cellHeight
        }
        return CGFloat.leastNonzeroMagnitude
    }
    
    // MARK: - Editing tableView
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        favorites.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        delegate?.favoritesPresenterDelegate(favoritesDidChange: favorites)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedLocation = indexPath.section == 0 ? nil : favorites[indexPath.row]
        delegate?.favoritesPresenterDelegate(didSelect: selectedLocation)
    }
    
}
