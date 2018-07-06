import UIKit

extension UICollectionViewCell {
    static func reuseIdentifier() -> String {
        return String(describing: self)
    }
}
