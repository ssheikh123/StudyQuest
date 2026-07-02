import SwiftUI

struct ChatsView: View {
    let settings: AppAccessibilitySettings

    var body: some View {
        PlaceholderScreen(
            title: "Chats",
            iconName: "message.fill",
            message: "Coming Soon",
            settings: settings
        )
    }
}
