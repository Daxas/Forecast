import Foundation
import UIKit

// MARK: - CollectionView life cycle
class HourlyCollectionPresenter: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var collectionView: UICollectionView
    private var forecast: Forecast?
    
    func update(with hourlyForecast: Forecast) {
        forecast = hourlyForecast
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: CGFloat((100)), height: CGFloat(88))
        } else {
            return CGSize(width: CGFloat((50)), height: CGFloat(88))
        }
    }
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section==0 {
            return 1
        } else {
            guard let forecast = forecast else {
                return 0
            }
            return (forecast.hourlyData?.count)!
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = cellIdentifier(forItemAt: indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        switch cell {
        case let cell as InfoCollectionViewCell:
            configureInfoCell(cell)
        case let cell as HourlyCollectionViewCell:
            configureHourlyCell(cell, indexPath: indexPath)
        default:
            break
        }
        return cell
    }
    
    private func cellIdentifier(forItemAt indexPath: IndexPath) -> String {
        if indexPath.section == 0 {
            return Identifier.infoCell.rawValue
        } else {
            return Identifier.hourlyCell.rawValue
        }
    }
    
    private func configureHourlyCell(_ cell: HourlyCollectionViewCell, indexPath: IndexPath) {
        guard let forecast = forecast else {
            return
        }
        let item = forecast.hourlyData![indexPath.row]
        let dateFormatter = DateFormatter()
        cell.hourlyImage.image = UIImage(named: item.icon)
        cell.hourlyTempLabel.text = dateFormatter.temperature(temp: item.temperature)
        cell.timeLabel.text = dateFormatter.getDateFromTimeInterval(time: item.time, to: .hour)
    }
    
    private func configureInfoCell(_ cell: InfoCollectionViewCell) {
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

