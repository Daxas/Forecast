
import UIKit
import CoreLocation

private let ForecastApiKey = "cfb098593c0899de76d374e96d68c8e3"

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        ForecastClient.Configuration.apiKey = ForecastApiKey
        
        let serviceFactory = ServiceFactory(coreFactory: CoreFactory())
        let presentationFactory = PresentationFactory(serviceFactory: serviceFactory)
        
        //window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = presentationFactory.createTabBar()
        window?.makeKeyAndVisible()
        /*
        let factory = PresentationFactory(serviceFactory: serviceFactory)
        
        guard let rootViewController = window?.rootViewController as? UITabBarController else {
            return true
        }
        for vc in rootViewController.viewControllers! {
            if let vc = vc as? ForecastViewController {
                //vc.forecastModel = factory.createForecastModel()
            }
            if let vc = vc as? UINavigationController,
                let favoritesVC = vc.viewControllers.first as? FavoritesViewController {
              //  favoritesVC.favoritesModel = factory.createFavoritesModel()
            }
        }*/
        return true
    }
    
}

