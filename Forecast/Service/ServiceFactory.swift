protocol ServiceFactoryProtocol {
   // func createFavoritesStore() -> FavoritesStoreProtocol
    func createForecastAdapter() -> ForecastAdapterProtocol
  //  func createAppSettings() -> AppSettingsProtocol
}

class ServiceFactory: ServiceFactoryProtocol {
    
    private let coreFactory: CoreFactoryProtocol
    
    init(coreFactory: CoreFactoryProtocol) {
        self.coreFactory = coreFactory
    }
    
    func createForecastAdapter() -> ForecastAdapterProtocol {
        let forecastAdapter = ForecastAdapter(geoCoder: coreFactory.createGeoCoder(), geoLocator: coreFactory.createGeoLocator(), forecastClient: coreFactory.createForecastClient())
        return forecastAdapter
    }
    
    /*func createAppSettings() -> AppSettingsProtocol {
        <#code#>
    }
    
    func createFavoritesStore() -> FavoritesStoreProtocol {
        <#code#>
    }*/
    
}
