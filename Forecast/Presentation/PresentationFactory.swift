import UIKit

protocol PresentationFactoryProtocol {
    func createForecastModel() -> ForecastModelProtocol
    func createFavoritesModel() -> FavoritesModel
}


class PresentationFactory: PresentationFactoryProtocol {
    
    private let serviceFactory: ServiceFactoryProtocol
    
    init(serviceFactory: ServiceFactoryProtocol) {
        self.serviceFactory = serviceFactory
    }
    
    func createForecastModel() -> ForecastModelProtocol {
        return ForecastModel(forecastService: serviceFactory.createForecastService())
    }
    
    func createFavoritesModel() -> FavoritesModel {
        let forecastModel = createForecastModel()
        return FavoritesModel(forecastAdapter: serviceFactory.createForecastService(), store: serviceFactory.createFavoritesStore(), appSettings: serviceFactory.createAppSettings(), forecastModel: forecastModel)
    }
    
    func createForecastModule() {
        let forecastModel = ForecastModel(forecastService: serviceFactory.createForecastService())
        let forecastVC = ForecastViewController(forecastModel: forecastModel)
        forecastVC.tabBarItem = UITabBarItem(title: "Weather.title".localized(), image: UIImage(named: "greyStar"), selectedImage: UIImage(named: "blueStar"))
       
        
    }
    
    
}
