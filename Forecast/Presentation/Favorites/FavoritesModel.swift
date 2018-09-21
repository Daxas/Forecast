protocol FavoritesModelDelegate: class {
    func update(with favorites: [ForecastPoint])
   // func updateCell(with point: ForecastPoint)
    func updateCurrentPointCell(with point: ForecastPoint)
}

protocol FavoritesModelOutput: class {
    func favoritesWasSelected(point: ForecastPoint)
}

class FavoritesModel {
    
    private var forecastService: ForecastServiceProtocol
    private var store: FavoritesStoreProtocol
    private var appSettings: AppSettingsProtocol
    
    weak var delegate: FavoritesModelDelegate?
    weak var favoritesModelOutput: FavoritesModelOutput?
   
    init(forecastAdapter: ForecastServiceProtocol, store: FavoritesStoreProtocol, appSettings: AppSettingsProtocol) {
        self.forecastService = forecastAdapter
        self.store = store
        self.appSettings = appSettings
    }
    
    func load() {
        let favorites = store.loadForecastPoints()
        delegate?.update(with: favorites)
    }
    
    func viewWillApear() {
       // let favorites = store.loadForecastPoints()
       fetchForecast()
        fetchCurrentForecast()
    }
    
    func fetchForecast() {
        var favoritesWithWeather = store.loadForecastPoints()
        let favorites = store.loadForecastPoints()
        for point in favorites {
            guard let index = favorites.index(of: point) else  {
                return
            }
            forecastService.getForecast(for: point, completion: { [weak self] in
                favoritesWithWeather[index] = $0
                //self?.delegate?.updateCell(with: $0)
                self?.delegate?.update(with: favoritesWithWeather)
                }, failure: {print($0)})
        }
    }
    
    func fetchCurrentForecast() {
        forecastService.getForecastForCurrentPoint(completion: {[weak self] in
            self?.delegate?.updateCurrentPointCell(with: $0)
            } , failure: {print($0)} )
    }
    
    
}

// MARK: - SearchResultControllerDelegate

extension FavoritesModel: SearchResultControllerDelegate {
    
    func searchResultControllerDelegate(didSelect point: ForecastPoint) {
        var favorites = store.loadForecastPoints()
        var pointInFavorites = false
        for favorPoint in favorites {
            if favorPoint.address?.city == point.address?.city {
                pointInFavorites = true
                break
            }
        }
        guard !pointInFavorites else {
            return
        }
        favorites.append(point)
        delegate?.update(with: favorites)
        forecastService.getAddress(for: point, completion: { [weak self] in
            point.address = $0.address
            self?.delegate?.update(with: favorites)
            self?.store.save(favorites: favorites)
            }, failure: {print($0)})
    }
}

// MARK: - FavoritesTablePresenterDelegate

extension FavoritesModel: FavoritesTablePresenterDelegate {
    
    func favoritesPresenterDelegate(didSelect point: ForecastPoint?) {
        guard let point = point else {
            return
        }
        favoritesModelOutput?.favoritesWasSelected(point: point)
        appSettings.setSelectedCoordinates(forecastPoint: point)
    }
    
    func favoritesPresenterDelegate(favoritesDidChange favorites: [ForecastPoint]) {
        store.save(favorites: favorites)
    }
    
}
