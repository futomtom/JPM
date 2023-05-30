import SwiftUI

struct HeaderView: View {
    @StateObject var searchModel: MKLocalSearchModel = .init()
    @ObservedObject var mainStore: MainViewModel
    @State private var isSearchSheetPresented = false
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color(UIColor.label))
            Text("...")
                .font(.title2)
                .fontWeight(.bold)
                .lineSpacing(10)
                .foregroundColor(Color(UIColor.label))
        }
        .onTapGesture {
            playHapticFeedback()
            isSearchSheetPresented.toggle()
        }
        .sheet(isPresented: $isSearchSheetPresented) {
            LocalSearchView(localSearchModel: searchModel, mainStore: mainStore, isSearchSheetPresented: $isSearchSheetPresented)
        }
        .padding(.top, 40)
    }
}

struct SearchHeader_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(mainStore: MainViewModel())
    }
}
