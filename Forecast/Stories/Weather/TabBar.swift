
import UIKit
import Foundation

enum TabItem: Int {
    case weather = 0
    case favorites
    
    var title: String {
        switch self {
        case .weather:
            return "Weather".localized()
        case .favorites:
            return "Favorites".localized()
        }
    }
}

class TabBar: UITabBarController {
    

    
    
}
