
import UIKit

class InfoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var windSpeedLabel: UILabel!
    @IBOutlet var pressureLabel: UILabel!
    @IBOutlet var humidityLabel: UILabel!
    
    func configure(with forecast: Forecast){
        windSpeedLabel.text = forecast.windSpeed.rounded().toString(afterPoint: 0) + "m/c"
        pressureLabel.text = forecast.pressure.rounded().toString(afterPoint: 0) + "hPA"
        humidityLabel.text = (forecast.humidity * 100).rounded().toString(afterPoint: 0) + "%"
    }
    
}


