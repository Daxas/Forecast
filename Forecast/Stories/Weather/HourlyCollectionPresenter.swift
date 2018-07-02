import Foundation
import UIKit

// MARK: - CollectionView life cycle
class HourlyCollectionPresenter: NSObject, UICollectionViewDataSource {
    
    var collectionView: UICollectionView
    var forecast: Forecast?
    
    func update(with hourlyForecast: Forecast) {
        forecast = hourlyForecast
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let forecast = forecast else {
            return 1
        }
        return (forecast.hourlyData?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = cellIdentifier(for: indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        switch cell {
        case let cell as InfoCollectionViewCell:
            configureInfoCell(cell, indexPath: indexPath)
        case let cell as HourlyCollectionViewCell:
            configureHourlyCell(cell, indexPath: indexPath)
        default:
            break
        }
            return cell
    }
    
   private func cellIdentifier(for itemAtIndexPath: IndexPath) -> String {
    if itemAtIndexPath.item == 0 {
        return Identifier.infoCell.rawValue
    } else {
        return Identifier.hourlyCell.rawValue
    }
    }
    
    private func configureHourlyCell(_ cell: HourlyCollectionViewCell, indexPath: IndexPath) {
        guard let forecast = forecast else {
            return
        }
        let item = forecast.hourlyData![indexPath.row - 1]
        cell.hourlyImage.image = UIImage(named: item.icon)
        cell.hourlyTempLabel.text = item.temperature.rounded().toString(afterPoint: 0)
       // cell.timeLabel.text = getDateFromTimeInterval(time: item.time, to: .hour)
    }
    
    private func configureInfoCell(_ cell: InfoCollectionViewCell, indexPath: IndexPath) {
        cell.humidityIcon.image = UIImage(named: "humidityIcon")
        cell.pressureIcon.image = UIImage(named: "pressureIcon")
        cell.windIcon.image = UIImage(named: "windIcon")
        guard let forecast = forecast else {
            return
        }
        cell.windSpeedLabel.text = forecast.windSpeed.rounded().toString(afterPoint: 0) + "m/c"
        cell.pressureLabel.text = forecast.pressure.rounded().toString(afterPoint: 0) + "hPA"
        cell.humidityLabel.text = (forecast.humidity * 100).rounded().toString(afterPoint: 0) + "%"
    }
    
    init(with collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
        collectionView.dataSource = self
    }
}

