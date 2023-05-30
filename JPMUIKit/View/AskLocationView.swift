import CoreLocation
import SwiftUI

struct AskLocationView: View {
    @ObservedObject var store: MainViewModel
    var body: some View {
        VStack {
            Spacer(minLength: 150)
            Text("Please share your location to get weather")
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            Button {
                store.requestUserLocation()
            } label: {
                Label("Current Location", systemImage: "location")
            }
        }
        .alert(isPresented: $store.showLocationAlert) {
            showAlert(
                $store.showLocationAlert,
                alert: .locationDenied,
                action: { UIApplication.shared.open(UIApplication.appSettingsURL) }
            )
        }
    }
}

struct NeedLocationView_Previews: PreviewProvider {
    static let store = MainViewModel()

    static var previews: some View {
        AskLocationView(store: store)
    }
}
