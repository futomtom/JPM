import SwiftUI

struct RemoteImage: View {
    let imageUrl: URL?
    @StateObject private var imageLoader: ImageLoader

    init(imageUrl: URL?) {
        self.imageUrl = imageUrl
        _imageLoader = StateObject(wrappedValue: ImageLoader(url: imageUrl))
    }

    var body: some View {
        ZStack {
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                Color.gray // Placeholder or loading indicator
            }
        }
        .onAppear {
            imageLoader.loadImage()
        }
    }
}
