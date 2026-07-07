import SwiftUI

struct ChatsView: View {
    let settings: AppAccessibilitySettings

    var body: some View {
        PlaceholderScreen(
            title: "Community",
            iconName: "bubble.left.and.bubble.right.fill",
            message: "Coming Soon",
            settings: settings
        )
    }
}
