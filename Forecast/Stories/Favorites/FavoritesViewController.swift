import UIKit
import CoreLocation

class FavoritesViewController: UIViewController {
    
    @IBOutlet var favoritesTableView: UITableView!
    
    lazy var favoritesTablePresenter = FavoritesTablePresenter(with: self.favoritesTableView)
    private let store = Store()
    private var firstTime = true
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favoritesTablePresenter.delegate = self
        configure()
        configureDataForTest()
        favoritesTablePresenter.update(with: store.load())
        
        
    }
    
    private func configureDataForTest() {
        if firstTime {
            var favoriteLocations = [CLLocation]()
            var favorites = [ForecastPoint]()
            favoriteLocations.append(CLLocation(latitude: 55.751244, longitude: 37.618423))
            favoriteLocations.append(CLLocation(latitude: 40.730610, longitude: -73.935242))
            favoriteLocations.append(CLLocation(latitude: 51.509865, longitude: -0.118092))
            for location in favoriteLocations {
                let point = ForecastPoint(with: location)
                favorites.append(point)
            }
            store.save(favorites: favorites)
        }
        firstTime = false
    }
    
    private func configure() {
        favoritesTableView.backgroundColor = UIColor.white
        
    }
    
}

extension FavoritesViewController: FavoritesTablePresenterDelegate {
    
    func favoritesTablePresenterDelegate(_ sender: FavoritesTablePresenter, favoritesDidChange: [ForecastPoint]) {
        store.save(favorites: favoritesDidChange)
    }
    
    
    func favoritesTablePresenterDelegate(_ sender: FavoritesTablePresenter, locationDidSelect point: ForecastPoint?) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LocationDidChange"), object: nil, userInfo: ["favorLocation": point as Any])
        if let forecastPoint = point {
            var coordinates = [Double]()
            coordinates.append(forecastPoint.location.coordinate.latitude)
            coordinates.append(forecastPoint.location.coordinate.longitude)
            UserDefaults.standard.set(coordinates, forKey: "SelectedLocationCoordinates")
        } else {
            UserDefaults.standard.set(nil, forKey: "SelectedLocationCoordinates")
        }
    }
    
    
    
    
}
