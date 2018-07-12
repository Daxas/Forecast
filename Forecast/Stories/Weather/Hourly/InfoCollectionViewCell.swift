
import UIKit

class InfoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var windSpeedLabel: UILabel!
    @IBOutlet var pressureLabel: UILabel!
    @IBOutlet var humidityLabel: UILabel!
    
    func configure(with forecast: Forecast){
        windSpeedLabel.text = String(forecast.windSpeed.rounded()) + "m/c".localized()
        pressureLabel.text = String(forecast.pressure.rounded()) + "hPA".localized()
        humidityLabel.text = String((forecast.humidity * 100).rounded()) + "%"
    }
    
}


