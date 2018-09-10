
import UIKit
import CoreLocation

private let ForecastApiKey = "cfb098593c0899de76d374e96d68c8e3"

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        ForecastClient.Configuration.apiKey = ForecastApiKey
        
        let forecastAdapter = ForecastAdapter(geoCoder: GeoCoder(), geoLocator: GeoLocator(), forecastClient: ForecastClient())
        let store = FavoritesStore()
        let forecastModel = ForecastModel(forecastAdapter: forecastAdapter)
        
        guard let rootViewController = window?.rootViewController as? UITabBarController else {
            return true
        }
            for vc in rootViewController.viewControllers! {
                if let vc = vc as? ForecastViewController {
                    forecastModel.delegate = vc
                    vc.forecastModel = forecastModel
                }
                if let vc = vc as? UINavigationController,
                    let favoritesVC = vc.viewControllers.first as? FavoritesViewController {
                        let favoritesModel = FavoritesModel(forecastAdapter: forecastAdapter, store: store, appSettings: AppSettings(), forecastModel: forecastModel)
                        favoritesVC.favoritesModel = favoritesModel
                    }
                } 
        return true
    }
    
}

