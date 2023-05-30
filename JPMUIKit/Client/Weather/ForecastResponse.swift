// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let forecastResponse = try? JSONDecoder().decode(ForecastResponse.self, from: jsonData)

import Foundation

// MARK: - ForecastResponse

struct ForecastResponse: Codable {
    let cod: String
    let message, cnt: Int
    let list: [Forecast]
}

// MARK: - List

struct Forecast: Codable {
    let main: Main
    let weather: [Weather]
    let wind: Wind
    let visibility: Int
    let dtTxt: String

    var hour: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        if let date = dateFormatter.date(from: dtTxt) {
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "h:mm a"
            return timeFormatter.string(from: date)
        } else {
            return ""
        }
    }

    enum CodingKeys: String, CodingKey {
        case main, weather, wind, visibility
        case dtTxt = "dt_txt"
    }
}

enum Pod: String, Codable {
    case d
    case n
}

enum MainEnum: String, Codable {
    case clear = "Clear"
    case clouds = "Clouds"
}
