import Foundation
import UIKit

final class ImageLoader: ObservableObject {
    @Published var image: UIImage?

    private let url: URL
    private let cache: URLCache

    init(url: URL) {
        self.url = url
        cache = URLCache.shared
    }

    func loadImage() {
        if let cachedResponse = cache.cachedResponse(for: URLRequest(url: url)),
           let image = UIImage(data: cachedResponse.data) {
            self.image = image
        } else {
            URLSession.shared.dataTask(with: url) { data, response, _ in
                guard let data = data, let response = response else { return }
                DispatchQueue.main.async {
                    if let image = UIImage(data: data) {
                        self.image = image
                    }
                    let cachedData = CachedURLResponse(response: response, data: data)
                    self.cache.storeCachedResponse(cachedData, for: URLRequest(url: self.url)) // Caches the response data.
                }
            }.resume()
        }
    }
}
