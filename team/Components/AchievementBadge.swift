import SwiftUI

struct AchievementBadge: View {
    let title: String
    let iconName: String
    let color: Color
    let isUnlocked: Bool

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: isUnlocked ? iconName : "lock.fill")
                .font(.title2.weight(.bold))
                .foregroundStyle(isUnlocked ? color : .secondary)
                .frame(width: 54, height: 54)
                .background((isUnlocked ? color : Color.secondary).opacity(0.14))
                .clipShape(Circle())

            Text(title)
                .font(.studyQuest(.caption, weight: .bold))
                .multilineTextAlignment(.center)
                .foregroundStyle(.primary)
        }
        .frame(maxWidth: .infinity)
        .accessibilityLabel(isUnlocked ? title : "\(title) locked")
    }
}
