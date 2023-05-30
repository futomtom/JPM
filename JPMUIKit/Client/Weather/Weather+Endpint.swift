import Foundation

extension WeatherClient {
    enum Endpoint {
        case current(city: City)
        case forecast(city: City)

        var path: String {
            switch self {
            case .current:
                return "weather"
            case .forecast:
                return "forecast"
            }
        }

        // Generate the URLRequest for the endpoint
        func MakeURLRequest() -> URLRequest {
            var urlComponents = URLComponents(string: WeatherClient.baseUrlString)!
            urlComponents.path += path
            urlComponents.queryItems = WeatherClient.queryItems

            switch self {
            case let .current(city):
                urlComponents.queryItems! += city.toQueryItems()

            case let .forecast(city: city):
                urlComponents.queryItems! += city.toQueryItems()
            }
            return URLRequest(url: urlComponents.url!)
        }
    }
}
