import UIKit
import CoreLocation

class FavoritesViewController: UIViewController {
    
    @IBOutlet var favoritesTableView: UITableView!
    
    var favoriteLocations = [CLLocation]()
    var favorites = [ForecastPoint]()
    var forecastAdapter = ForecastAdapter()
    
    private lazy var favoritesTablePresenter = FavoritesTablePresenter(with: self.favoritesTableView)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        favoriteLocations.append(CLLocation(latitude: 55.75, longitude: 37.62))
        favoriteLocations.append(CLLocation(latitude: 56.328, longitude: 44.005))
        favoriteLocations.append(CLLocation(latitude: 8.072, longitude: 98.9105))
        
        forecastAdapter.getForecastForCurrentPoint(completion: {[weak self] in
            self?.favoritesTablePresenter.update(with: $0)
            } , failure: {print($0)} )
        for location in favoriteLocations {
            forecastAdapter.getForecastAndAddress(for: location, completion: { (point) in
                self.favorites.append(point)
                self.favoritesTablePresenter.update(favorites: self.favorites)
            }, failure: {print($0)})
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
}


