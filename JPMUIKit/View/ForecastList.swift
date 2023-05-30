import SwiftUI

struct ForecastList: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass
    let forecasts: [Forecast]
    private var isLandScape: Bool {
        verticalSizeClass == .compact
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack() {
                ForEach(forecasts, id: \.dtTxt) { forecast in
                    HourView(forecast)
                        .frame(maxWidth: .infinity, maxHeight: 240)
                }
            }
        }
        .padding(.horizontal)
    }
}

struct ForecastList_Previews: PreviewProvider {
    static var previews: some View {
        ForecastList(forecasts: [])
    }
}
