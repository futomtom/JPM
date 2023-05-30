import SwiftUI

struct HourView: View {
    let time: String
    let iconURL: URL?
    let temperature: String

    init(_ forecast: Forecast) {
        time = forecast.hour
        iconURL = forecast.weather.first?.iconURL
        temperature = forecast.main.temperature
    }

    init(_ time: String, iconURL: URL, temperature: String) {
        self.time = time
        self.iconURL = iconURL
        self.temperature = temperature
    }

    var body: some View {
        VStack() {
            Text(time)
            Spacer(minLength: 1)
            RemoteImage(imageUrl: iconURL)
                .frame(width: 48, height: 48)
            Spacer(minLength: 1)
            Text(temperature)
        }
        .fontStyle(20)
        .padding()
        .foregroundColor(.white)
        .blueGradientBackground()
    }
}

struct HourView_Previews: PreviewProvider {
    static var previews: some View {
        HourView("10AM", iconURL: URL(string: "https:/www.google.com")!, temperature: "10C")
            .frame(width: 160, height: 160)
    }
}
