import CoreLocation
import Foundation
import SwiftUI

// Structure representing a city with name, latitude, and longitude
struct City: Codable {
    var name: String?
    var latitude: Double?
    var longitude: Double?

    init(_ name: String, _ latitude: Double, longitude: Double) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }

    init(_ name: String, coordinate: CLLocationCoordinate2D) {
        self.name = name
        latitude = coordinate.latitude
        longitude = coordinate.longitude
    }
}

extension City {
    // Convert City to an array of URLQueryItem
    func toQueryItems() -> [URLQueryItem] {
        ["lat": latitude ?? 0, "lon": longitude ?? 0].toQueryItems()
    }

    private static let savedCityKey = "savedCity"

    // Get or set the savedCity using UserDefaults
    static var savedCity: City? {
        get {
            if let data = UserDefaults.standard.data(forKey: savedCityKey),
               let city = try? JSONDecoder().decode(City.self, from: data) {
                return city
            }
            return nil
        }
        set {
            if let encodedData = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(encodedData, forKey: savedCityKey)
            } else {
                UserDefaults.standard.removeObject(forKey: savedCityKey)
            }
        }
    }
}
