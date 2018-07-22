import UIKit
import CoreLocation

class FavoritesViewController: UIViewController {
    
    @IBOutlet var favoritesTableView: UITableView!
    
    var favoriteLocations = [CLLocation]()
    var favorites = [ForecastPoint]()
    var forecastAdapter = ForecastAdapter()
    
    private var didGetAddress = false
    lazy var favoritesTablePresenter = FavoritesTablePresenter(with: self.favoritesTableView)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        favoriteLocations.append(CLLocation(latitude: 55.751244, longitude: 37.618423))
        favoriteLocations.append(CLLocation(latitude: 40.730610, longitude: -73.935242))
        favoriteLocations.append(CLLocation(latitude: 51.509865, longitude: -0.118092))
        
        fetchCurrentForecast()
        fetchFavoriteAddress()
        fetchFavoriteForecast()
        //favoritesTablePresenter.update(favorites: self.favorites)
   }
    
    // MARK: - Data
    
    private func fetchCurrentForecast() {
        print("ask for Current Forecast")
        forecastAdapter.getForecastForCurrentPoint(completion: {[weak self] in
            self?.favoritesTablePresenter.update(with: $0)
            print(" get Current Forecast")
            } , failure: {print($0)} )
    }
    
    private func fetchFavoriteAddress() {
        if didGetAddress == false {
             print("ask for Favorites Address")
            for location in favoriteLocations {
                let point = ForecastPoint(with: location)
                forecastAdapter.getAddress(for: point, completion: { (favoritePoint) in
                    point.address = favoritePoint.address
                    self.favorites.append(point)
                   // self.fetchFavoriteForecast()
                    self.favoritesTablePresenter.update(favorites: self.favorites)
                }, failure: {print($0)})
            }
            didGetAddress = true
            print(" get Favorites Address")
        }
    }
    
    private func fetchFavoriteForecast(){
       // if didGetAddress {
            print("ask for Favorites Forecast")
            for favorPoint in favorites {
                forecastAdapter.getForecast(for: favorPoint, completion: { (point) in
                    favorPoint.forecast = point.forecast
                   self.favoritesTablePresenter.update(favorites: self.favorites)
                }, failure: {print($0)})
            }
      //  }
        print(" get Favorites Forecast")
    }
}


