import UIKit
import CoreLocation

class FavoritesViewController: UIViewController {
    
    @IBOutlet var favoritesTableView: UITableView!
    
    lazy var favoritesTablePresenter = FavoritesTablePresenter(with: self.favoritesTableView)
    private let store = FavoritesStore()
    
    // MARK: - Life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favoritesTablePresenter.update(with: store.loadForecastPoints())
        NotificationCenter.default.addObserver(self, selector: #selector(addPointToFavorites(notification:)), name: Notification.Name("SelectedSearchResult"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("SelectedSearchResult"), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoritesTablePresenter.delegate = self
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
        let searchResultController = SearchResultController()
        navigationItem.searchController = UISearchController(searchResultsController: searchResultController)
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController?.searchResultsUpdater = searchResultController
        navigationItem.searchController?.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController?.searchBar.placeholder = "City or area".localized()
        definesPresentationContext = true
    }
    
    @objc private func addPointToFavorites(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        guard let newLocation = userInfo["SelectedSearchResult"] as? ForecastPoint else {
            return
        }
        var favorites = store.loadForecastPoints()
        favorites.append(newLocation)
        store.save(favorites: favorites)
        favoritesTablePresenter.update(with: favorites)
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
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LocationDidChange"), object: nil, userInfo: ["favorLocation": point as Any])
        AppSettings().setSelectedCoordinates(forecastPoint: point)
    }
    
    func favoritesPresenterDelegate(favoritesDidChange favorites: [ForecastPoint]) {
        store.save(favorites: favorites)
    }
    
}

