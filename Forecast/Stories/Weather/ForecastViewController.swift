
import UIKit
//import MapKit
import CoreLocation

enum Identifier: String {
    case hourlyCell = "HourlyCell"
    case infoCell = "infoCell"
    case dailyTableCell = "Daily"
}



class ForecastViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var collectionView: UICollectionView!
    
    private lazy var dailyTablePresenter = DailyTablePresenter(with: self.tableView)
    private lazy var hourlyCollectionPresenter = HourlyCollectionPresenter(with: self.collectionView)

    
    @IBOutlet var adressLabel: UILabel!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var summaryLabel: UILabel!
    @IBOutlet var iconImage: UIImageView!
    
    let forecastClient = ForecastClient()
    var forecast: Forecast?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let location = CLLocation(latitude: 56.23, longitude: 43.411)
        adressLabel.text = GeoCoder().geoCode(for: location)
        presentForecast(for: location)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Private
    
    private func presentForecast(for location: CLLocation) {
        forecastClient.getForecast(for: location, completion: {[weak self] in
            self?.forecast = $0
            self?.dailyTablePresenter.update(with: $0)
            self?.hourlyCollectionPresenter.update(with: $0)
            self?.show($0)
            self?.adressLabel.text = GeoCoder().geoCode(for: location)
            }, failure: {print($0)})
    }
    
    private func show(_ forecast: Forecast){
        let dateFormatter = DateFormatter()
        tempLabel.text = dateFormatter.temperature(temp: forecast.temperature)
        summaryLabel.text = forecast.summary
        iconImage.image = UIImage(named: forecast.icon)
       
    }
    
    
    
}

