import SwiftUI

struct TextStyle: ViewModifier {
    let fontSize: CGFloat
    func body(content: Content) -> some View {
        content
            .font(.system(size: fontSize, weight: .bold))
    }
}

extension View {
    func fontStyle(_ size: CGFloat) -> some View {
        modifier(TextStyle(fontSize: size))
    }
}
