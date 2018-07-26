import Foundation
import CoreLocation

let directory = "Forecast.plist"
let key = "FavoriteLocations"

class Store {
    
    // MARK: - Saving and Loading data
    
   
    
    private func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    private func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent(directory)
    }
    
    func save(favorites: [ForecastPoint]) {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(favorites, forKey: key)
        archiver.finishEncoding()
        data.write(to: dataFilePath(), atomically: true)
    }
    

    
    func load() -> [ForecastPoint] {
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            let favorites = unarchiver.decodeObject(forKey: key) as! [ForecastPoint]
            unarchiver.finishDecoding()
            return favorites
        } else {
            return [ForecastPoint]()
        }
    }
    
}
