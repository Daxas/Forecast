
import CoreLocation

protocol ForecastModelDelegate: class {
    func updateAddressLabels(with forecastPoint: ForecastPoint?)
    func updateWeatherLabels(with forecastPoint: ForecastPoint?)
}

protocol ForecastModelProtocol: class {
    func viewWillAppear()
    func viewDidLoad()
    func favoritesWasSelected(point: ForecastPoint)
}

class ForecastModel: ForecastModelProtocol {
    
    private var forecastService: ForecastServiceProtocol
    private var forecastPoint: ForecastPoint?
    
    weak var delegate: ForecastModelDelegate?
    
    init(forecastService: ForecastServiceProtocol) {
        self.forecastService = forecastService
    }
    
    func viewWillAppear() {
        delegate?.updateAddressLabels(with: forecastPoint)
        getForecast()
    }
    
    func viewDidLoad() {
        guard let coordinates = AppSettings().getSelectedCoordinates() else {
            forecastPoint = nil
            return
        }
        forecastPoint = ForecastPoint(with: coordinates)
        
        forecastService.getAddress(for: forecastPoint!, completion: { [weak self] in
            self?.forecastPoint?.address = $0.address
            self?.delegate?.updateAddressLabels(with: self?.forecastPoint)
            }, failure: {print($0)})
    }
    
   func favoritesWasSelected(point: ForecastPoint) {
        forecastPoint = point
        fetchForecast()
    }
    
    // MARK: - Private
    
    private func getForecast() {
        guard forecastPoint == nil else {
            fetchForecast()
            return
        }
        fetchCurrentForecast()
    }
    
    private func fetchCurrentForecast() {
        forecastService.getForecastForCurrentPoint(completion: { [weak self] in
            self?.delegate?.updateWeatherLabels(with: $0)
            self?.delegate?.updateAddressLabels(with: $0)
            }, failure: {print($0)})
    }
    
    private func fetchForecast() {
        guard let point = forecastPoint else {
            return
        }
        forecastService.getForecast(for: point, completion: { [weak self] in
            point.forecast = $0.forecast
            self?.delegate?.updateWeatherLabels(with: point)
            }, failure: {print($0)})
    }
    
}
