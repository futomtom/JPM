import CoreLocation
import MapKit
import SwiftUI

@MainActor
final class MainViewModel: NSObject, ObservableObject {
    @Published var city: City?
    @Published var showPermissionAlert: Bool = false
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var weather: WeatherResponse?
    @Published var forecast: ForecastResponse?
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
        // if location is granted when App in background, then city will not be updated if it is already present.
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

    // Fetch weather data for a given city
    func fetchWeather(city: City) {
        Task {
            isLoading = true
            async let weatherTask: WeatherResponse = WeatherClient.shared.fetch(.current(city: city))
            async let forecastTask: ForecastResponse = WeatherClient.shared.fetch(.forecast(city: city))

            do {
                weather = try await weatherTask
                forecast = try await forecastTask
            } catch {
                // Handle any errors that occurred during fetching the weather or forecast
                print("Error fetching weather data: \(error)")
            }

            isLoading = false
        }
    }

    // Update the selected city based on the MKLocalSearch from user's input
    func updateCity(searchResult: MKLocalSearchCompletion) {
        getCoordinates(searchCompletion: searchResult) { [weak self] coordinates in
            let name = searchResult.title.split(separator: ",")[0].description
            let newCity = City(name, coordinates.latitude, longitude: coordinates.longitude)
            self?.city = newCity
            City.savedCity = newCity
            self?.fetchWeather(city: newCity)
        }
    }

    // Get coordinates for a given localSearch result
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
        showPermissionAlert = status == .denied
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
