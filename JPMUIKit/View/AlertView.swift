// AlertView.swift

import SwiftUI

enum AlertType {
    case locationDenied

    var title: String {
        switch self {
        case .locationDenied:
            return "Location disabled"
        }
    }

    var message: String {
        switch self {
        case .locationDenied:
            return "Please enable location in Settings"
        }
    }
}

struct AlertView: View {
    @Binding var isPresented: Bool
    var alert: AlertType

    var body: some View {
        VStack {
            Text(alert.title)
                .font(.title)
                .padding()

            Text(alert.message)

            Button("Dismiss") {
                isPresented = false
            }
            .padding()
        }
        .frame(width: 300, height: 200)
        .background(Color.white)
        .cornerRadius(10)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AlertView(isPresented: .constant(true), alert: .locationDenied)
    }
}
