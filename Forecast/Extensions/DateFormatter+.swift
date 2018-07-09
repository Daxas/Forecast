
import Foundation

enum DateFormatterType: String {
    case weekday = "EEEE"
    case hour = "hh:mm"
    case date = "dd MMMM"
    case day = "dd"
    
    var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = self.rawValue
        return formatter
    }
}

extension DateFormatter {
    func temperature(temp: Double) -> String {
        var temperature = temp.rounded().toString(afterPoint: 0)
        temperature = temp > 0 ? "+" + temperature : temperature
        return temperature + "°"
    }
    
    func date(date: Date) -> String {
        let date = getDateFromTimeInterval(time: date, to: .date)
        if date.first == "0" {
            return String(date.dropFirst() )
        } else {
            return date
        }
    }
    
    func weekDay(date: Date) -> String {
        let day = Int(getDateFromTimeInterval(time: date, to: .day))
        if day == currentDay() {
            return "Today"
        } else if day == currentDay() + 1 {
            return "Tomorrow"
        } else {
        return getDateFromTimeInterval(time: date, to: .weekday)
        }
    }
    
    private func currentDay() -> Int{
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
       return day
    }
    
    func getDateFromTimeInterval(time: Date, to type: DateFormatterType) -> String {
        return type.formatter.string(from: time as Date)
    }
   
}
