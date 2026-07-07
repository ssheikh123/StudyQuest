import SwiftUI

struct CoinCounter: View {
    let coins: Int
    let settings: AppAccessibilitySettings

    var body: some View {
        Label("\(coins)", systemImage: "circle.hexagongrid.fill")
            .font(.studyQuest(.headline, weight: .bold))
            .foregroundStyle(AppTheme.goldReward)
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(AppTheme.goldReward.opacity(settings.darkMode ? 0.18 : 0.14))
            .clipShape(Capsule())
            .accessibilityLabel("\(coins) coins")
    }
}
