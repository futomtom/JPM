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
        VStack(spacing: 16) {
            Text(time)
            RemoteImage(imageUrl: iconURL!)
                .frame(minWidth: 80, minHeight: 80)
            Text(temperature)
        }
        .fontStyle(20)
        .padding()
        .foregroundColor(.white)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.blue.opacity(0.5)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
        )
    }
}

struct HourView_Previews: PreviewProvider {
    static var previews: some View {
        HourView("10AM", iconURL: URL(string: "https:/www.google.com")!, temperature: "10C")
            .frame(width: 160, height: 160)
    }
}
