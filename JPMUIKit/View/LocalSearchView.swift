import MapKit
import SwiftUI

struct LocalSearchView: View {
    @ObservedObject var localSearchModel: MKLocalSearchModel
    @ObservedObject var mainStore: MainViewModel

    @State private var showCityList = true
    @Binding var isSearchSheetPresented: Bool

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Find City")) {
                        ZStack(alignment: .trailing) {
                            TextField("Search", text: $localSearchModel.queryText)
                        }
                    }
                    .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                        localSearchModel.queryText = ""

                        showCityList = true
                    }
                    .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
                        showCityList = false
                    }

                    Section {
                        List {
                            // TODO: Handle empty result or error
                            ForEach(localSearchModel.searchResults, id: \.self) { completionResult in
                                Label("\(completionResult.title)", systemImage: "thermometer.low")
                                    .onTapGesture {
                                        mainStore.updateCity(searchResult: completionResult)
                                        isSearchSheetPresented = false
                                    }
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("", displayMode: .inline)
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing, content: {
                    Button("Dismiss", action: {
                        isSearchSheetPresented = false
                        playHapticFeedback()
                    })
                })
            })
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        LocalSearchView(localSearchModel: MKLocalSearchModel(), mainStore: MainViewModel(), isSearchSheetPresented: .constant(true))
    }
}
