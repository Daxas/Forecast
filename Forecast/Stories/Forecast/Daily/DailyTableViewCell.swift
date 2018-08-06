import UIKit

struct Identifier {
    static let dailyTableCell = "Daily"
}

class DailyTableViewCell: UITableViewCell {

    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var maxTempLabel: UILabel!
    @IBOutlet var minTempLabel: UILabel!
    @IBOutlet var weekDayLabel: UILabel!
    @IBOutlet var iconDaily: UIImageView!
    
}
