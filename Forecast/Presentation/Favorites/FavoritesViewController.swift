import UIKit
import CoreLocation

class FavoritesViewController: UIViewController {
    
    @IBOutlet var favoritesTableView: UITableView!
    
    private lazy var favoritesTablePresenter = FavoritesTablePresenter(with: self.favoritesTableView)
    var store: FavoritesStore!
    var forecastAdapter: ForecastAdapter!
    
    init(forecastAdapter: ForecastAdapter, store: FavoritesStore) {
        self.forecastAdapter = forecastAdapter
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoritesTablePresenter.delegate = self
        favoritesTablePresenter.update(with: store.loadForecastPoints())
        configure()
    }
    
    // MARK: - Private
    
    private func configure() {
        favoritesTableView.backgroundColor = UIColor.white
        navigationItem.title = "Favorites.title".localized()
        navigationController?.tabBarItem.title = "Favorites.title".localized()
        navigationItem.rightBarButtonItem?.title = "Edit".localized()
        configureSearchController()
    }
    
    private func configureSearchController() {
        guard let searchResultController = storyboard?.instantiateViewController(withIdentifier: "SearchResultController") as? SearchResultController else {
            fatalError("Unable to instatiate a SearchResultController from the storyboard.")
        }
        searchResultController.delegate = self
        if #available(iOS 11.0, *) {
            navigationItem.searchController = UISearchController(searchResultsController: searchResultController)
            navigationItem.searchController?.searchResultsUpdater = searchResultController
            navigationItem.searchController?.searchBar.placeholder = "City or area".localized()
            navigationItem.searchController?.obscuresBackgroundDuringPresentation = false
        } else {
            // Fallback on earlier versions
            let searchController = UISearchController(searchResultsController: searchResultController)
            searchController.searchBar.placeholder = "City or area".localized()
            searchController.searchResultsUpdater = searchResultController
            searchController.obscuresBackgroundDuringPresentation = false
            searchController.searchBar.delegate = searchResultController as UISearchBarDelegate
            favoritesTableView.tableHeaderView = searchController.searchBar
        }
        definesPresentationContext = true
    }
    
    // MARK: - IBActions
    
    @IBAction func editBarButton(_ sender: Any) {
        if favoritesTableView.isEditing {
            favoritesTableView.isEditing = false
            navigationItem.rightBarButtonItem?.title = "Edit".localized()
        } else {
            favoritesTableView.isEditing = true
            navigationItem.rightBarButtonItem?.title = "Done".localized()
        }
    }
    
}

// MARK: - FavoritesTablePresenterDelegate

extension FavoritesViewController: FavoritesTablePresenterDelegate {
    
    func favoritesPresenterDelegate(didSelect point: ForecastPoint?) {
        NotificationCenter.default.post(name: .locationDidChange, object: nil, userInfo: ["favorLocation": point as Any])
        AppSettings().setSelectedCoordinates(forecastPoint: point)
    }
    
    func favoritesPresenterDelegate(favoritesDidChange favorites: [ForecastPoint]) {
        store.save(favorites: favorites)
    }
    
}

// MARK: - SearchResultControllerDelegate

extension FavoritesViewController: SearchResultControllerDelegate {
    
    func searchResultControllerDelegate(didSelect point: ForecastPoint) {
        if #available(iOS 11.0, *) {
            navigationItem.searchController?.searchBar.text = ""
        } else {
            // Fallback on earlier versions
            
        }
        var favorites = store.loadForecastPoints()
        var pointInFavorites = false
        for favorPoint in favorites {
            if favorPoint.address?.city == point.address?.city {
                pointInFavorites = true
                break
            }
        }
        guard !pointInFavorites else {
            return
        }
        favorites.append(point)
        favoritesTablePresenter.update(with: favorites)
        forecastAdapter.getAddress(for: point, completion: { [weak self] in
            point.address = $0.address
            self?.favoritesTablePresenter.update(with: favorites)
            self?.store.save(favorites: favorites)
            }, failure: {print($0)})
    }
    
}
