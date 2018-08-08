import UIKit
import Foundation
import CoreLocation

enum ResultCells: Int {
    case searchResult = 0
    case error
    
    var cellIdentifier: String {
        switch self {
        case .searchResult:
            return "SearchResultCell"
        case .error:
            return "ErrorCell"
        }
    }
    
    static var cellHeight: CGFloat {
        return CGFloat(60)
    }
}

protocol SearchResultControllerDelegate: class {
    func searchResultControllerDelegate(didSelect point: ForecastPoint)
}

class SearchResultController: UITableViewController, UISearchResultsUpdating {
    
    private let geoCoder = GeoCoder()
    private var searchingResults = [CLPlacemark]()
    
    weak var delegate: SearchResultControllerDelegate?
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let textForSearch = searchController.searchBar.text else {
            return
        }
        searchingLocation(textForSearch)
    }
    
    // MARK: - TableView live cycle
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchingResults.count == 0 ? 1 : searchingResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard searchingResults.count != 0 else {
            let errorCell = tableView.dequeueReusableCell(withIdentifier: ResultCells.error.cellIdentifier, for: indexPath) as! SearchResultErrorCell
            errorCell.configure()
            return errorCell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: ResultCells.searchResult.cellIdentifier, for: indexPath)
        guard let searchCell = cell as? SearchResultCell else {
            return UITableViewCell()
        }
        let searchedPoint = searchingResults[indexPath.row]
        searchCell.cityLabel.text = searchedPoint.locality
        searchCell.detailLabel.text = searchedPoint.thoroughfare
        return searchCell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ResultCells.cellHeight
    }
    
    // MARK: - Editing TableView
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPlacemark = searchingResults[indexPath.row]
        if let location = selectedPlacemark.location {
            let selectedPoint = ForecastPoint(with: location, placemark: selectedPlacemark)
            delegate?.searchResultControllerDelegate(didSelect: selectedPoint)
            dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Private
    
    private func searchingLocation(_ textForSearch: String) {
        geoCoder.geoSearching(for: textForSearch, completion: { (placemarks) in
            self.searchingResults = placemarks
            self.tableView.reloadData()
        }, failure: {print($0)
            print("geoCoder.geoSearching: NO location for current text")
        })
    }
    
}

extension SearchResultController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchingLocation(searchText)
    }
}

