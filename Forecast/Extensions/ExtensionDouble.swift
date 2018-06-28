

import Foundation

extension Double {
    func toString(afterPoint: Int) -> String {
        let format = "%." + String(afterPoint) + "f"
        return String(format: format, self)
    }
}
