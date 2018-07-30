import Foundation
import CoreLocation

private let directory = "Forecast.plist"
private let key = "FavoriteLocations"

class FavoritesStore {
    
    // MARK: - Public
    
    func save(favorites: [ForecastPoint]) {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(favorites, forKey: key)
        archiver.finishEncoding()
        data.write(to: dataFilePath(), atomically: true)
    }
    
    func loadForecastPoints() -> [ForecastPoint] {
        let path = dataFilePath()
        guard let data = try? Data(contentsOf: path) else {
            return [ForecastPoint]()
        }
        let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
        let favorites = unarchiver.decodeObject(forKey: key) as! [ForecastPoint]
        unarchiver.finishDecoding()
        return favorites
    }
    
    // MARK: - Private
    
    private func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    private func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent(directory)
    }
    
}
