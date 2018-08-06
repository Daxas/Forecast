import UIKit
import Foundation
import CoreLocation

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
        geoCoder.geoSearching(for: textForSearch, completion: { (placemarks) in
            self.searchingResults = placemarks
            self.tableView.reloadData()
        }, failure: {print($0)
            print("geoCoder.geoSearching: NO location for current text")
        })
    }
    
    // MARK: - TableView live cycle
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchingResults.count == 0 ? 1 : searchingResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard searchingResults.count != 0 else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ErrorCell", for: indexPath) as! SearchResultErrorCell
            cell.errorLabel.text = "NO location for current text"
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath)
        guard let searchCell = cell as? SearchResultCell else {
            return UITableViewCell()
        }
        searchCell.cityLabel.text = searchingResults[indexPath.row].locality
        searchCell.detailLabel.text = searchingResults[indexPath.row].thoroughfare
        return searchCell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //
        return FavoritesSections.favorites.cellHeight
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
    
}

