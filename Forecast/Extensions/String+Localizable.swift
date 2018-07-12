import Foundation

extension String {
    
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
    
    func localized(_ parameters: String...) -> String {
        return String(format: localized(), arguments: parameters)
    }
    
}

