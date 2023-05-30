import Combine
import Foundation
import MapKit

class MKLocalSearchModel: NSObject, ObservableObject {
    @Published var queryText: String = ""
    @Published private(set) var searchResults: [MKLocalSearchCompletion] = []

    private var queryCancellable: AnyCancellable?
    private let searchCompleter: MKLocalSearchCompleter!

    init(searchCompleter: MKLocalSearchCompleter = MKLocalSearchCompleter()) {
        self.searchCompleter = searchCompleter
        super.init()
        self.searchCompleter.delegate = self

        queryCancellable = $queryText
            .receive(on: DispatchQueue.main)
            .debounce(for: .milliseconds(150), scheduler: RunLoop.main, options: nil)
            .sink(receiveValue: { fragment in
                if !fragment.isEmpty {
                    self.searchCompleter.queryFragment = fragment
                } else {
                    self.searchResults = []
                }
            })
    }
}

extension MKLocalSearchModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
    }
}
