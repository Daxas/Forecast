import Foundation
import UIKit

struct Constants {
    static let infoCellWidth = CGFloat(100)
    static let hourlyCellWidth = CGFloat(50)
    static let cellHeight = CGFloat(88)
}

enum Sections: Int {
    case info = 0
    case hourlyData
    
    var cellIdentifier: String {
        switch self {
        case .info:
            return InfoCollectionViewCell.reuseIdentifier()
        case .hourlyData:
            return HourlyCollectionViewCell.reuseIdentifier()
        }
    }
    
    static var count: Int {
        return 2
    }
}

class HourlyPresenter: NSObject {
    
    private var collectionView: UICollectionView
    private var forecast: Forecast?
    private let dateFormatter = DateFormatter()
    
    func update(with hourlyForecast: Forecast) {
        forecast = hourlyForecast
        
        collectionView.reloadData()
    }
    
    
    
    
    private func configureHourlyCell(_ cell: HourlyCollectionViewCell, indexPath: IndexPath) {
        guard let forecast = forecast else {
            return
        }
        let item = forecast.hourlyData[indexPath.row]
        cell.hourlyImage.image = UIImage(named: item.icon)
        cell.hourlyTempLabel.text = dateFormatter.temperature(temp: item.temperature)
        cell.timeLabel.text = dateFormatter.getDateFromTimeInterval(time: item.time, to: .hour)
        
    }
    
    private func configureInfoCell(_ cell: InfoCollectionViewCell) {
        guard let forecast = forecast else {
            return
        }
        
        cell.configure(with: forecast)
    }
    
    init(with collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}


extension HourlyPresenter: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return forecast != nil ? Sections.count : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let forecast = forecast else {
            return 0
        }
        return section == 0 ? 1 : forecast.hourlyData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let section = Sections(rawValue: indexPath.section) else {
            return UICollectionViewCell()
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: section.cellIdentifier, for: indexPath)
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
}

extension HourlyPresenter: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                                 layout collectionViewLayout: UICollectionViewLayout,
                                 sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = indexPath.section == 0 ? Constants.infoCellWidth : Constants.hourlyCellWidth
        return CGSize(width: width, height: Constants.cellHeight)
    }
    
}





