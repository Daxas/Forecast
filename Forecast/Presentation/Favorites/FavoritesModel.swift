protocol FavoritesModelDelegate: class {
    func update(with favorites: [ForecastPoint])
}

protocol FavoritesCellInput: class {
    func configure(with: ForecastPoint?)
}

class FavoritesModel {
    
    private var forecastService: ForecastServiceProtocol
    private var store: FavoritesStoreProtocol
    private var appSettings: AppSettingsProtocol
    private var forecastModel: ForecastModelProtocol
    
    weak var delegate: FavoritesModelDelegate?
    weak var cellInput: FavoritesCellInput?
    
    init(forecastAdapter: ForecastServiceProtocol, store: FavoritesStoreProtocol, appSettings: AppSettingsProtocol, forecastModel: ForecastModelProtocol) {
        self.forecastService = forecastAdapter
        self.store = store
        self.appSettings = appSettings
        self.forecastModel = forecastModel
    }
    
    func load() {
        let favorites = store.loadForecastPoints()
        delegate?.update(with: favorites)
    }
    
    func fetchForecast(for point: ForecastPoint) {
        forecastService.getForecast(for: point, completion: { [weak self] in
            self?.cellInput?.configure(with: $0)
            //self?.delegate?.update(with: <#T##[ForecastPoint]#>)
            }, failure: {print($0)})
    }
    
    func fetchCurrentForecast() {
        forecastService.getForecastForCurrentPoint(completion: {[weak self] in
            self?.cellInput?.configure(with: $0)
            
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
        forecastModel.favoritesWasSelected(point: point)
        appSettings.setSelectedCoordinates(forecastPoint: point)
    }
    
    func favoritesPresenterDelegate(favoritesDidChange favorites: [ForecastPoint]) {
        store.save(favorites: favorites)
    }
    
}
