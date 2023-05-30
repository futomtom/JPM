import SwiftUI

struct LoadingView: View {
    @Environment(\.colorScheme) var colorScheme
    var isLoading: Bool

    private var isDarkMode: Bool {
        colorScheme == .dark
    }

    var body: some View {
        ZStack {
            if isLoading {
                VStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.5)
                        .padding()

                    Text("Loading...")
                        .font(.headline)
                        .foregroundColor(isDarkMode ? .white : .gray)
                }
                .background(isDarkMode ? Color.black.opacity(0.5) : Color.white.opacity(0.5))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView(isLoading: true)
    }
}
