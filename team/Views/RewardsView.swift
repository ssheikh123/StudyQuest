import SwiftUI

struct RewardsView: View {
    let settings: AppAccessibilitySettings

    var body: some View {
        PlaceholderScreen(
            title: "Rewards",
            iconName: "gift.fill",
            message: "Coming Soon",
            settings: settings
        )
    }
}
