import CoreLocation
import Foundation
import SwiftUI

extension Dictionary where Key == String, Value: CustomStringConvertible {
    // Convert the dictionary to an array of URLQueryItem
    func toQueryItems() -> [URLQueryItem] {
        return map { key, value in
            let stringValue = String(describing: value)
            return URLQueryItem(name: key, value: stringValue)
        }
    }
}

/// Easily throw generic errors with a text description.
extension String: LocalizedError {
    public var errorDescription: String? {
        return self
    }
}

extension CLLocation {
    // Retrieve the city name from location and return this city
    func city() async -> City {
        let cityName = try? await CLGeocoder().reverseGeocodeLocation(self).first?.locality
        let city = City(cityName ?? "", coordinate: coordinate)
        City.savedCity = city
        return city
    }
}

extension View {
    func fontStyle(_ size: CGFloat) -> some View {
        modifier(TextStyle(fontSize: size))
    }

    func showAlert(
        _ isPresented: Binding<Bool>,
        alert: AlertType,
        action: (() -> Void)? = nil
    ) -> Alert {
        Alert(
            title: Text(alert.title),
            message: Text(alert.message),
            primaryButton: .default(Text("Settings")) {
                action?()
            },
            secondaryButton: .cancel()
        )
    }

    func playHapticFeedback() {
        let hapticFeedback = UIImpactFeedbackGenerator(style: .rigid)
        hapticFeedback.impactOccurred(intensity: 0.5)
    }

    func overlayLoadingView(isLoading: Bool) -> some View {
        overlay(
            LoadingView(isLoading: isLoading)
        )
    }

    func blueGradientBackground() -> some View {
        modifier(BackgroundModifier())
    }
}

extension UIApplication {
    // Get the app settings URL
    static let appSettingsURL: URL = {
        let bundleId = Bundle.main.bundleIdentifier ?? ""
        if #available(iOS 16, *) {
            return URL(string: UIApplication.openNotificationSettingsURLString + bundleId)!
        }

        if #available(iOS 15.4, *) {
            return URL(string: UIApplicationOpenNotificationSettingsURLString + bundleId)!
        }

        return URL(string: UIApplication.openSettingsURLString + bundleId)!
    }()
}
