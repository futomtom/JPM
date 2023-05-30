import SwiftUI

struct VHStack<Content: View>: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass

    let content: Content

    init(@ViewBuilder _ content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        // let _ = debug()
        if verticalSizeClass == .compact {
            HStack {
                content
            }
            .frame(maxWidth: .infinity)
        } else {
            VStack {
                content
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
    }
}
