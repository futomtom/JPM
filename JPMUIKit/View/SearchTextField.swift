import SwiftUI

struct SearchTextField: View {
    @Binding var searchText: String

    var body: some View {
        TextField("Search", text: $searchText)
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
            .padding()
    }
}

struct SearchTextField_Previews: PreviewProvider {
    static var previews: some View {
        SearchTextField(searchText: .constant("San Jose"))
    }
}
