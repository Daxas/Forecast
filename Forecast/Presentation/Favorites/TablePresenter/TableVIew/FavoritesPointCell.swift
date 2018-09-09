 
import UIKit

class FavoritesPointCell: UITableViewCell {
    
    @IBOutlet var currentLocationLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var subAddressLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var weatherIcon: UIImageView!
    
    private let forecastAdapter = ForecastAdapter(geoCoder: GeoCoder(), geoLocator: GeoLocator(), forecastClient: ForecastClient())
    //var forecastAdapter: ForecastAdapter!
    private let temperatureUtils = TemperatureUtils()
    
    /*init(forecastAdapter: ForecastAdapter) {
        self.forecastAdapter = forecastAdapter
        super.init(style: .default, reuseIdentifier: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    */
    // MARK: - Public
    
    func configureFavoritesCell(with point: ForecastPoint) {
        updateCellWeatherLabels(with: nil)
        updateCellAddressLabels(with: point)
        forecastAdapter.getForecast(for: point, completion: { [weak self] in
            self?.updateCellWeatherLabels(with: $0)
            }, failure: {print($0)})
    }
    
    func configureCurrentLocationCell() {
        updateCellAllLabels(with: nil)
        forecastAdapter.getForecastForCurrentPoint(completion: {[weak self] in
            self?.updateCellAllLabels(with: $0)
            } , failure: {print($0)} )
    }
    
    // MARK: - Private
    
    private func updateCellWeatherLabels(with forecastPoint: ForecastPoint?) {
        if let forecastPoint = forecastPoint, let forecast = forecastPoint.forecast {
            temperatureLabel.text = temperatureUtils.getTemperatureFrom(number: forecast.temperature)
            if reuseIdentifier == FavoritesSections.current.cellIdentifier {
                weatherIcon.image = UIImage(named: forecast.icon)
            } else {
                weatherIcon.image = UIImage(named: forecast.icon + "_")
            }
        } else {
            temperatureLabel.text = ""
            weatherIcon.image = nil
        }
        
    }
    
    private func updateCellAddressLabels(with forecastPoint: ForecastPoint?) {
        if let forecastPoint = forecastPoint, let address = forecastPoint.address {
            addressLabel.text = address.city
            subAddressLabel.text = address.detail
        } else {
            addressLabel.text = "-"
            subAddressLabel.text = "-.-"
        }
    }
    
    private func updateCellAllLabels(with forecastPoint: ForecastPoint?) {
        updateCellAddressLabels(with: forecastPoint)
        updateCellWeatherLabels(with: forecastPoint)
    }
}
