import UIKit
import Foundation
import CoreLocation

class SearchResultController: UITableViewController, UISearchResultsUpdating {
    
    private let geoCoder = GeoCoder()
    private var searchingResults = [CLPlacemark]()
    
    override func viewDidLoad() {
        let cellNib = UINib.init(nibName: "SearchResultCell", bundle: Bundle.main)
        tableView.register(cellNib, forCellReuseIdentifier: "SearchResult")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let textForSearch = searchController.searchBar.text else {
            return
        }
        geoCoder.geoSearching(for: textForSearch, completion: { (placemarks) in
            self.searchingResults = placemarks
            self.tableView.reloadData()
        }, failure: {print($0)
            print("NO location for current text")
        })
    }
    
    // MARK: - TableView live cycle
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchingResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResult", for: indexPath)
        guard let searchCell = cell as? SearchResultCell else {
            return UITableViewCell()
        }
        searchCell.cityLabel.text = searchingResults[indexPath.row].locality
        searchCell.detailLabel.text = searchingResults[indexPath.row].subLocality
        return searchCell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return FavoritesSections.favorites.cellHeight
    }
    
    // MARK: - Editing TableView
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPlacemark = searchingResults[indexPath.row]
        if let location = selectedPlacemark.location {
            let selectedPoint = ForecastPoint(with: location, placemark: selectedPlacemark)
            NotificationCenter.default.post(name: NSNotification.Name("SelectedSearchResult"), object: nil, userInfo: ["SelectedSearchResult": selectedPoint as Any])
            dismiss(animated: true, completion: nil)
        }
    }
    
}

