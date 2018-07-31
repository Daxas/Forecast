
import UIKit

class FavoritesPointCell: UITableViewCell {
    
    @IBOutlet var currentLocationLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var subAddressLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var weatherIcon: UIImageView!
    
    private let forecastAdapter = ForecastAdapter()
    private let temperatureUtils = TemperatureUtils()
    
    // MARK: - Public
    
    func configureFavoritesCell(with point: ForecastPoint) {
        updateCell(with: point)
        forecastAdapter.getForecastAndAddress(for: point, completion: { [weak self] in
            self?.updateCell(with: $0)
            }, failure: {print($0)})
    }
    
    func configureCurrentLocationCell() {
        forecastAdapter.getForecastForCurrentPoint(completion: {[weak self] in
            self?.updateCell(with: $0)
            } , failure: {print($0)} )
    }
    
    // MARK: - Private
    
    private func updateCell(with forecastPoint: ForecastPoint) {
        if let forecast = forecastPoint.forecast {
            temperatureLabel.text = temperatureUtils.getTemperatureFrom(number: forecast.temperature)
            if reuseIdentifier == FavoritesSections.current.cellIdentifier {
                weatherIcon.image = UIImage(named: forecast.icon)
            } else {
                weatherIcon.image = UIImage(named: forecast.icon + "_")
            }
        } else {
            temperatureLabel.text = "--"
        }
        if let address = forecastPoint.address{
            addressLabel.text = address.city
            subAddressLabel.text = address.detail
        } else {
            addressLabel.text = "-"
            subAddressLabel.text = "-.-"
        }
    }
    
}

