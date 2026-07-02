import SwiftUI

enum AppTheme {
    static let cornerRadius: CGFloat = 8
    static let cardShadow = Color.black.opacity(0.07)

    static func brandGradient(colorblindMode: Bool) -> LinearGradient {
        LinearGradient(
            colors: colorblindMode
                ? [Color.orange, Color.teal, Color.indigo]
                : [Color.purple, Color.blue, Color.cyan],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
