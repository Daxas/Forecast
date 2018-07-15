
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
    
    func string(from date: Date) -> String {
        return formatter.string(from: date)
    }
}


class DateUtils {
    
    static var weekdayFormatter: DateFormatter = {
        return DateFormatterType.weekday.formatter
    }()
    static var dayNumberFormatter: DateFormatter = {
        return DateFormatterType.date.formatter
    }()
    static var timeFormatter: DateFormatter = {
        return DateFormatterType.hour.formatter
    }()
    
    func date(date: Date) -> String {
        let date = DateUtils.dayNumberFormatter.string(from: date)
        if date.first == "0" {
            return String(date.dropFirst() )
        }
        
        return date
    }
    
    func weekDay(date: Date) -> String {
        if Calendar.current.isDateInToday(date) {
            return "Today".localized()
        }
        
        if Calendar.current.isDateInTomorrow(date) {
            return "Tomorrow".localized()
        }
        
        return DateUtils.weekdayFormatter.string(from: date)
    }
    
    
    
}
