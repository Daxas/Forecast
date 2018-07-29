import UIKit
import CoreLocation

class FavoritesViewController: UIViewController {
    
    @IBOutlet var favoritesTableView: UITableView!
    
    lazy var favoritesTablePresenter = FavoritesTablePresenter(with: self.favoritesTableView)
    private let store = FavoritesStore()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoritesTablePresenter.delegate = self
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favoritesTablePresenter.update(with: store.loadForecastPoints())
    }
    
    // MARK: - Private
    
    private func configure() {
        favoritesTableView.backgroundColor = UIColor.white
        navigationItem.title = "Favorites.title".localized()
        tabBarItem.title = "Favorites.title".localized()
        navigationItem.rightBarButtonItem?.title = "Edit".localized()
    }
    
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

extension FavoritesViewController: FavoritesTablePresenterDelegate {
    
    func favoritesPresenterDelegate(didSelect point: ForecastPoint?) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LocationDidChange"), object: nil, userInfo: ["favorLocation": point as Any])
        AppSettings().setSelectedCoordinates(forecastPoint: point)
    }
    
    func favoritesPresenterDelegate(favoritesDidChange favorites: [ForecastPoint]) {
        store.save(favorites: favorites)
    }
    
}
