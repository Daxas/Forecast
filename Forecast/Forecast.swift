

import Foundation


class Forecast {
var time: NSDate?
    var summary: String?
var icon = ""
var temperature = 0.0
    var humidity: Float?
    var pressure: Float?
    var windSpeed: Float?
    
}

class DailyForecast {
    var time: NSDate?
    var icon = ""
    var temperatureHigh = 0.0
    var temperatureLow = 0.0
}
