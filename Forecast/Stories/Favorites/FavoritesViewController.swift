import UIKit
import CoreLocation

class FavoritesViewController: UIViewController {
    
    @IBOutlet var favoritesTableView: UITableView!
    
    private var favoriteLocations = [CLLocation]()
    lazy var favoritesTablePresenter = FavoritesTablePresenter(with: self.favoritesTableView)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favoriteLocations.append(CLLocation(latitude: 55.751244, longitude: 37.618423))
        favoriteLocations.append(CLLocation(latitude: 40.730610, longitude: -73.935242))
        favoriteLocations.append(CLLocation(latitude: 51.509865, longitude: -0.118092))
        favoriteLocations.append(CLLocation(latitude: 55.751244, longitude: 37.618423))
        favoriteLocations.append(CLLocation(latitude: 40.730610, longitude: -73.935242))
        favoriteLocations.append(CLLocation(latitude: 51.509865, longitude: -0.118092))
        favoriteLocations.append(CLLocation(latitude: 55.751244, longitude: 37.618423))
        favoriteLocations.append(CLLocation(latitude: 40.730610, longitude: -73.935242))
        favoriteLocations.append(CLLocation(latitude: 51.509865, longitude: -0.118092))
        favoriteLocations.append(CLLocation(latitude: 55.751244, longitude: 37.618423))
        favoriteLocations.append(CLLocation(latitude: 40.730610, longitude: -73.935242))
        favoriteLocations.append(CLLocation(latitude: 51.509865, longitude: -0.118092))
        favoritesTablePresenter.makeFavorites(locations: favoriteLocations)
    }
    
    
    
    
}


