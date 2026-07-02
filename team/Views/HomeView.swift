import SwiftUI

struct HomeView: View {
    let settings: AppAccessibilitySettings

    var body: some View {
        PlaceholderScreen(
            title: "Home",
            iconName: "house.fill",
            message: "Coming Soon",
            settings: settings
        )
    }
}
