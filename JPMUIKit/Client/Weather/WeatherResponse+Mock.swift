import Foundation

extension WeatherResponse {
    static let jsonData = """
    {
        "coord": {
            "lon": -121.9809,
            "lat": 37.2958
        },
        "weather": [
            {
                "id": 804,
                "main": "Clouds",
                "description": "overcast clouds",
                "icon": "04n"
            }
        ],
        "base": "stations",
        "main": {
            "temp": 13.19,
            "feels_like": 12.58,
            "temp_min": 10.62,
            "temp_max": 14.74,
            "pressure": 1013,
            "humidity": 77
        },
        "visibility": 10000,
        "wind": {
            "speed": 2.06,
            "deg": 20
        },
        "clouds": {
            "all": 100
        },
        "dt": 1685339037,
        "sys": {
            "type": 2,
            "id": 2004572,
            "country": "US",
            "sunrise": 1685278256,
            "sunset": 1685330388
        },
        "timezone": -25200,
        "id": 5333689,
        "name": "Campbell",
        "cod": 200
    }
    """.data(using: .utf8)!

    static func mock() throws -> WeatherResponse {
        let decoder = JSONDecoder()
        let weatherResponse = try decoder.decode(WeatherResponse.self, from: WeatherResponse.jsonData)
        return weatherResponse
    }
}
