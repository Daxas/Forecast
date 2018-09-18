import UIKit

protocol PresentationFactoryProtocol {
    func createForecastModule(forecastModel: ForecastModel) -> ForecastViewController
    func createFavoritesModule(forecastModel: ForecastModel) -> FavoritesViewController
    func createTabBar() -> UITabBarController
}


class PresentationFactory: PresentationFactoryProtocol {
    
    
    private let serviceFactory: ServiceFactoryProtocol
    
    init(serviceFactory: ServiceFactoryProtocol) {
        self.serviceFactory = serviceFactory
    }
    
    func createForecastModule(forecastModel: ForecastModel) -> ForecastViewController {
        let forecastVC = ForecastViewController(forecastModel: forecastModel)
        forecastVC.tabBarItem = UITabBarItem(title: "Weather.title".localized(), image: UIImage(named: "greyStar"), selectedImage: UIImage(named: "blueStar"))
        return forecastVC
    }
    
    func createFavoritesModule(forecastModel: ForecastModel) -> FavoritesViewController {
        let favoritesModel = FavoritesModel(forecastAdapter: serviceFactory.createForecastService(), store: serviceFactory.createFavoritesStore(), appSettings: serviceFactory.createAppSettings(), forecastModel: forecastModel)
        let favoritesVC = FavoritesViewController(favoritesModel: favoritesModel)
        return favoritesVC
    }
    
    func createTabBar() -> UITabBarController {
        let model = createForecastModel()
        let forecastVC = createForecastModule(forecastModel: model)
        let favoritesVC = createFavoritesModule(forecastModel: model)
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
}
