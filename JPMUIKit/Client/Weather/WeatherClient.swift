import CoreLocation
import Foundation

struct WeatherClient {
    static let version = 2.5
    static let APIKey = "aa4f0fb37ee08a981e67e88402a08cc2"
    static let baseUrlString = "https://api.openweathermap.org/data/\(version)/"
    static let queryItems = [URLQueryItem(name: "appid", value: APIKey), URLQueryItem(name: "units", value: "metric")]
    static let shared = WeatherClient()

    private let session = URLSession.shared

    func fetch<T: Decodable>(_ endpoint: WeatherClient.Endpoint) async throws -> T {
        let request = endpoint.MakeURLRequest()

        let (data, response) = try await session.data(for: request)
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.fetchFailure
        }

        if case 200 ... 299 = response.statusCode {
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                return result
            } catch {
                throw NetworkError.decodeFailure
            }
        } else {
            throw NetworkError.fetchFailure
        }
    }
}
