 
import UIKit

class FavoritesPointCell: UITableViewCell {
    
    @IBOutlet var currentLocationLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var subAddressLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var weatherIcon: UIImageView!
    
    private let temperatureUtils = TemperatureUtils()
    
    func configure(with forecastPoint: ForecastPoint?) {
        if let forecastPoint = forecastPoint, let forecast = forecastPoint.forecast {
            temperatureLabel.text = temperatureUtils.getTemperatureFrom(number: forecast.temperature)
            if reuseIdentifier == FavoritesSections.current.cellIdentifier {
                currentLocationLabel.text = "Current location".localized()
                weatherIcon.image = UIImage(named: forecast.icon)
            } else {
                weatherIcon.image = UIImage(named: forecast.icon + "_")
            }
        } else {
            temperatureLabel.text = ""
            weatherIcon.image = nil
        }
        if let forecastPoint = forecastPoint, let address = forecastPoint.address {
            addressLabel.text = address.city
            subAddressLabel.text = address.detail
        } else {
            addressLabel.text = "-"
            subAddressLabel.text = "-.-"
        }
    }
    
 }
