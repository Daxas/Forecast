
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
    
}
