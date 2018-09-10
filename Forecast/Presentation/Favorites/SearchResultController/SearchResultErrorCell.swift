import UIKit

class SearchResultErrorCell: UITableViewCell {
    
    @IBOutlet var errorLabel: UILabel!
    
    func configure() {
        errorLabel.text = "NO location for current text".localized()
    }
    
}
