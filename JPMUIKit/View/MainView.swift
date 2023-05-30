import CoreLocation
import SwiftUI

struct MainView: View {
    @StateObject var store: MainViewModel

    var body: some View {
        NavigationView {
            ZStack {
                VStack(alignment: .center, spacing: 20) {
                    HeaderView(mainStore: store)
                    WeatherView(weather: store.weather)
                        .onAppear {
                            fetchWeatherOrLocationIfNeeded()
                        }
                        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                            store.requestUserLocation()
                        }
                        .overlayLoadingView(isLoading: store.isLoading)
                    if true {
                        ForecastList(forecasts: store.forecast?.list ?? [])
                    }
                    Spacer()
                }
                if store.authorizationStatus == .denied, store.city == nil {
                    AskLocationView(store: store)
                }
            }
        }
    }
}

extension MainView {
    private func fetchWeatherOrLocationIfNeeded() {
        guard store.weather == nil else {
            return
        }

        if let city = store.city {
            store.fetchWeather(city: city)
        } else {
            store.requestUserLocation()
        }
    }
}

struct Main_Previews: PreviewProvider {
    static var previews: some View {
        MainView(store: MainViewModel())
    }
}
