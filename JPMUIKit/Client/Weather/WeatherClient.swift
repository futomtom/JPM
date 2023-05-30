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
            let decoder = JSONDecoder()
            do {
                let result = try decoder.decode(T.self, from: data)
                return result
            } catch let error as DecodingError {
                switch error {
                case let .dataCorrupted(context):
                    print("Data Corrupted error: \(context.debugDescription)")
                case let .keyNotFound(key, context):
                    print("Key Not Found error: \(key.stringValue), debugDescription: \(context.debugDescription)")
                case let .typeMismatch(type, context):
                    print("Type Mismatch error: \(type), debugDescription: \(context.debugDescription)")
                case let .valueNotFound(type, context):
                    print("Value Not Found error: \(type), debugDescription: \(context.debugDescription)")
                @unknown default:
                    print("Unknown decoding error occurred")
                }
                throw NetworkError.decodeFailure
            } catch {
                throw NetworkError.decodeFailure
            }
        } else {
            throw NetworkError.fetchFailure
        }
    }
}
