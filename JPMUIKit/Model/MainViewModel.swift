import CoreLocation
import MapKit
import SwiftUI

@MainActor
final class MainViewModel: NSObject, ObservableObject {
    @Published var city: City?
    @Published var showLocationAlert: Bool = false
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var weather: WeatherResponse?
    @Published var isLoading: Bool = false

    private var locationManager: CLLocationManager = .init()

    override init() {
        super.init()
        city = City.savedCity
        if let city {
            fetchWeather(city: city)
        }
    }

    func requestUserLocation() {
        if let city = city {
            fetchWeather(city: city)
            return
        }

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse {
            locationManager.requestLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }

    func fetchWeather(city: City) {
        Task {
            isLoading = true
            weather = try? await WeatherClient.shared.fetch(.current(city: city))
            isLoading = false
        }
    }

    func updateCity(searchResult: MKLocalSearchCompletion) {
        getCoordinates(searchCompletion: searchResult) { [weak self] coordinates in
            let name = searchResult.title.split(separator: ",")[0].description
            let newCity = City(name, coordinates.latitude, longitude: coordinates.longitude)
            self?.city = newCity
            City.savedCity = newCity
            self?.fetchWeather(city: newCity)
        }
    }

    private func getCoordinates(searchCompletion: MKLocalSearchCompletion, completion: @escaping (CLLocationCoordinate2D) -> Void) {
        let searchRequest = MKLocalSearch.Request(completion: searchCompletion)
        let search = MKLocalSearch(request: searchRequest)

        search.start { response, _ in
            let coordinates = response?.mapItems[0].placemark.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)
            completion(coordinates)
        }
    }
}

extension MainViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatus = status
        showLocationAlert = status == .denied
        manager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        Task {
            city = await location.city()
            if let city {
                fetchWeather(city: city)
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
