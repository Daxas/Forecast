import UIKit
import CoreLocation

class FavoritesViewController: UIViewController {
    
    @IBOutlet var favoritesTableView: UITableView!
    
    var favoritesModel: FavoritesModel!
    private lazy var favoritesTablePresenter = FavoritesTablePresenter(with: self.favoritesTableView)
    
    init(favoritesModel: FavoritesModel) {
        self.favoritesModel = favoritesModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        favoritesTablePresenter.delegate = favoritesModel
        favoritesModel.delegate = self
        favoritesModel.load()
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
        searchResultController.delegate = favoritesModel//self as? SearchResultControllerDelegate
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

// MARK: - FavoritesModelDelegate

extension FavoritesViewController: FavoritesModelDelegate {
    
    func update(with favorites: [ForecastPoint]) {
        favoritesTablePresenter.update(with: favorites)
    }
    
}

