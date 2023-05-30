import SwiftUI

struct ForecastList: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass
    let forecasts: [Forecast]
    private var isLandScape: Bool {
        verticalSizeClass == .compact
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 20) {
                ForEach(forecasts, id: \.dtTxt) { forecast in
                    HourView(forecast)
                }
            }
        }
        .padding(.horizontal)
        .frame(height: isLandScape ? 200 : 300)
    }
}

struct ForecastList_Previews: PreviewProvider {
    static var previews: some View {
        ForecastList(forecasts: [])
    }
}
