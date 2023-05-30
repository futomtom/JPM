import CoreLocation
import SwiftUI

struct WeatherView: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass
    var weather: WeatherResponse?
    private var isLandscape: Bool {
        verticalSizeClass == .compact
    }

    var body: some View {
        if let weather {
            main(weather: weather)
        } else {
            EmptyView()
        }
    }

    private func main(weather: WeatherResponse) -> some View {
        VHStack {
            titleView(weather)
            subtitleView(weather)
        }
    }

    private func titleView(_ weather: WeatherResponse) -> some View {
        VStack {
            Text(weather.name)
                .fontStyle(32)
            Text(weather.main.temperature)
                .fontStyle(64)
        }
    }

    private func subtitleView(_ weather: WeatherResponse) -> some View {
        VStack(spacing: 10) {
            HStack {
                if let iconURL = weather.weather.first?.iconURL {
                    RemoteImage(imageUrl: iconURL)
                        .frame(width: 20, height: 20)
                }
                Text(weather.weather.first?.description ?? "")
            }
            Text(weather.main.subtitle)
        }
        .padding()
        .fontStyle(20)
        .blueGradientBackground()
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(weather: try! WeatherResponse.mock())
        // .previewInterfaceOrientation(.landscapeLeft) // iOS 15+
    }
}
