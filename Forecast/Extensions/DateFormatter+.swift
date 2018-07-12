
import Foundation

enum DateFormatterType: String {
    case weekday = "EEEE"
    case hour = "hh:mm"
    case date = "dd MMMM"
    
    var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = self.rawValue
        return formatter
    }
}


extension DateFormatter {
    
    func date(date: Date) -> String {
        let date = getDateFromTimeInterval(time: date, to: .date)
        if date.first == "0" {
            return String(date.dropFirst() )
        } else {
            return date
        }
    }
    
    func weekDay(date: Date) -> String {
        if Calendar.current.isDateInToday(date) {
            return "Today".localized()
        } else if Calendar.current.isDateInTomorrow(date) {
            return "Tomorrow".localized()
        } else {
        return getDateFromTimeInterval(time: date, to: .weekday)
        }
    }
    
    func getDateFromTimeInterval(time: Date, to type: DateFormatterType) -> String {
        return type.formatter.string(from: time as Date)
    }
   
}
