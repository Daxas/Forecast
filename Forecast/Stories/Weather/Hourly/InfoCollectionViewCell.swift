
import UIKit

class InfoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var windSpeedLabel: UILabel!
    @IBOutlet var pressureLabel: UILabel!
    @IBOutlet var humidityLabel: UILabel!
    
    func configure(with forecast: Forecast){
        windSpeedLabel.text = String(Int(forecast.windSpeed.rounded())) + " m/c".localized()
        pressureLabel.text = String(Int(forecast.pressure.rounded())) + " hPA".localized()
        humidityLabel.text = String(Int((forecast.humidity * 100).rounded())) + " %"
    }
    
}


