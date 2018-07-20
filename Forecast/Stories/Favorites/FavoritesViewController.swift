import UIKit
import CoreLocation

class FavoritesViewController: UIViewController {
    
    @IBOutlet var favoritesTableView: UITableView!
    
    var forecastAdapter = ForecastAdapter()
    var currentWeather: ForecastPoint?
     private lazy var favoritesTablePresenter = FavoritesTablePresenter(with: self.favoritesTableView)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        forecastAdapter.getForecastForCurrentPoint(completion: {[weak self] in
            self?.currentWeather = $0
            self?.favoritesTablePresenter.update(with: $0)
            } , failure: {print($0)} )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
}

