protocol ServiceFactoryProtocol {
    func createFavoritesStore() -> FavoritesStoreProtocol
    func createForecastService() -> ForecastServiceProtocol
    func createAppSettings() -> AppSettingsProtocol
}

class ServiceFactory: ServiceFactoryProtocol {
    
    private let coreFactory: CoreFactoryProtocol
    
    init(coreFactory: CoreFactoryProtocol) {
        self.coreFactory = coreFactory
    }
    
    func createForecastService() -> ForecastServiceProtocol {
        let forecastAdapter = ForecastService(geoCoder: coreFactory.createGeoCoder(), geoLocator: coreFactory.createGeoLocator(), forecastClient: coreFactory.createForecastClient())
        return forecastAdapter
    }
    
    func createFavoritesStore() -> FavoritesStoreProtocol {
        return FavoritesStore()
    }
    
    func createAppSettings() -> AppSettingsProtocol {
        return AppSettings()
    }
}
