import CoreLocation
import SwiftUI

struct WeatherView: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass
    var weather: WeatherResponse?
    private var isPortrait: Bool {
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
            if isPortrait {
                Spacer()
            }
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
            if isPortrait, let iconURL = weather.weather.first?.iconURL {
                RemoteImage(imageUrl: iconURL)
                    .frame(width: 48, height: 48)
            }
            Text(weather.weather.first?.description ?? "")
            Text(weather.main.subtitle)
        }
        .fontStyle(20)
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(weather: try! WeatherResponse.mock())
        // .previewInterfaceOrientation(.landscapeLeft) // iOS 15+
    }
}
