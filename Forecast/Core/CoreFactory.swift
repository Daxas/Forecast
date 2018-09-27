
protocol CoreFactoryProtocol {
     func createGeoLocator() -> GeoLocatorProtocol
     func createGeoCoder() -> GeoCoder
     func createForecastClient() -> NetWorkClientProtocol
    
}

class CoreFactory: CoreFactoryProtocol {
    
     func createGeoLocator() -> GeoLocatorProtocol {
        return GeoLocator()
    }
    
     func createGeoCoder() -> GeoCoder {
        return GeoCoder()
    }
    
     func createForecastClient() -> NetWorkClientProtocol {
        return NetWorkClient()
    }
    
    
    
}

