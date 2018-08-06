
import UIKit
import CoreLocation

private let ForecastApiKey = "cfb098593c0899de76d374e96d68c8e3"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        ForecastClient.Configuration.apiKey = ForecastApiKey
        //prepareFakeData()
        return true
    }
    
    
    private func prepareFakeData() {
        let store = FavoritesStore()
        var favorites = store.loadForecastPoints()
        guard favorites.isEmpty else {
            return
        }
        var favoriteLocations = [CLLocation]()
        favoriteLocations.append(CLLocation(latitude: 55.751244, longitude: 37.618423))
        favoriteLocations.append(CLLocation(latitude: 40.730610, longitude: -73.935242))
        favoriteLocations.append(CLLocation(latitude: 51.509865, longitude: -0.118092))
        favoriteLocations.append(CLLocation(latitude: 55.751244, longitude: 37.618423))
        favoriteLocations.append(CLLocation(latitude: 40.730610, longitude: -73.935242))
        favoriteLocations.append(CLLocation(latitude: 51.509865, longitude: -0.118092))
        
        for location in favoriteLocations {
            let point = ForecastPoint(with: location)
            favorites.append(point)
        }
        store.save(favorites: favorites)
    }
    
}

