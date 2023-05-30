import CoreLocation
import Foundation

class LocationUpdater: NSObject, CLLocationManagerDelegate {
    private(set) var city: City?
    private(set) var authorizationStatus: CLAuthorizationStatus

    private let locationManager: CLLocationManager

    private var permissionContinuation: CheckedContinuation<CLAuthorizationStatus, Never>?
    private var cityContinuation: CheckedContinuation<City?, Error>?

    override init() {
        locationManager = CLLocationManager()
        authorizationStatus = locationManager.authorizationStatus

        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestPermission() async {
        guard authorizationStatus == .notDetermined else {
            return
        }

        locationManager.requestWhenInUseAuthorization()
        let authorizationStatus = await withCheckedContinuation { continuation in
            permissionContinuation = continuation
        }
        self.authorizationStatus = authorizationStatus
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        permissionContinuation?.resume(returning: authorizationStatus)
        permissionContinuation = nil
    }

    func getLocation() async throws -> City? {
        print("🙂", #function)
        city = try await withCheckedThrowingContinuation { continuation in
            cityContinuation = continuation
            locationManager.startUpdatingLocation()
        }
        return city
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("🙂", #function)
        locationManager.stopUpdatingLocation()
        guard let location = locations.first else {
            cityContinuation?.resume(throwing: "Location update failed")
            return
        }

        Task {
            let city = await location.getCity()
            cityContinuation?.resume(returning: city)
            cityContinuation = nil
            permissionContinuation = nil
        }
        cityContinuation = nil
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("🙂", #function)
        cityContinuation?.resume(throwing: error)
        cityContinuation = nil
    }
}
