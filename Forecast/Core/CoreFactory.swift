
protocol CoreFactoryProtocol {
     func createGeoLocator() -> GeoLocatorProtocol
     func createGeoCoder() -> GeoCoder
     func createForecastClient() -> ForecastClientProtocol
    
}

class CoreFactory: CoreFactoryProtocol {
    
     func createGeoLocator() -> GeoLocatorProtocol {
        return GeoLocator()
    }
    
     func createGeoCoder() -> GeoCoder {
        return GeoCoder()
    }
    
     func createForecastClient() -> ForecastClientProtocol {
        return ForecastClient()
    }
    
    
    
}

