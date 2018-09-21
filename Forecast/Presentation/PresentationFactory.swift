import UIKit

protocol PresentationFactoryProtocol {
    func createForecastModule() -> ForecastViewController
    func createFavoritesModule() -> FavoritesViewController
    func createTabBarController() -> UITabBarController
}

class PresentationFactory: PresentationFactoryProtocol {
    
    private let serviceFactory: ServiceFactoryProtocol
    
    init(serviceFactory: ServiceFactoryProtocol) {
        self.serviceFactory = serviceFactory
    }
    
    func createForecastModule() -> (ForecastViewController) {
        let forecastVC = UIStoryboard(name: "Weather", bundle: nil).instantiateViewController(withIdentifier: "ForecastViewController") as! ForecastViewController
        forecastVC.forecastModel = createForecastModel()
        forecastVC.tabBarItem = UITabBarItem(title: "Weather.title".localized(), image: UIImage(named: "greyStar"), selectedImage: UIImage(named: "blueStar"))
        return forecastVC
    }
    
    func createFavoritesModule() -> FavoritesViewController {
        let favoritesVC = UIStoryboard(name: "Favorites", bundle: nil).instantiateViewController(withIdentifier: "FavoritesViewController") as! FavoritesViewController
        favoritesVC.favoritesModel = createFavoritesModel()
        return favoritesVC
    }
    
    func createTabBarController() -> UITabBarController {
        let forecastVC = createForecastModule()
        let favoritesVC = createFavoritesModule()
        
        //???
        favoritesVC.favoritesModel.favoritesModelOutput = forecastVC.forecastModel as? FavoritesModelOutput
       
        let navigationVC = UINavigationController(rootViewController: favoritesVC)
        navigationVC.tabBarItem = UITabBarItem(title: "Favorites.title".localized(), image: UIImage(named: "greyStar"), selectedImage: UIImage(named: "blueStar"))
        let tabBar = UITabBarController(nibName: nil, bundle: nil)
        tabBar.viewControllers = [forecastVC, navigationVC]
        return tabBar
    }
    
    
    // MARK: - Private
    
    private func createForecastModel() -> ForecastModel {
        let forecastModel = ForecastModel(forecastService: serviceFactory.createForecastService())
        return forecastModel
    }
    
    private func createFavoritesModel() -> FavoritesModel {
        let favoritesModel = FavoritesModel(forecastAdapter: serviceFactory.createForecastService(), store: serviceFactory.createFavoritesStore(), appSettings: serviceFactory.createAppSettings())
        return favoritesModel
    }
}
