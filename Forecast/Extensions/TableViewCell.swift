import UIKit

extension UITableViewCell {
    static func reuseIdentifier() -> String {
        return String(describing: self)
    }
}
