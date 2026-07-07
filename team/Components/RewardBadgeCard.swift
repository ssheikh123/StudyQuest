import SwiftUI

struct RewardBadgeCard: View {
    let badge: RewardBadge
    let settings: AppAccessibilitySettings

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: badge.isUnlocked ? badge.iconName : "lock.fill")
                .font(.title2.weight(.bold))
                .foregroundStyle(badge.isUnlocked ? badge.color : .secondary)
                .frame(width: 58, height: 58)
                .background((badge.isUnlocked ? badge.color : Color.secondary).opacity(0.14))
                .clipShape(Circle())

            VStack(spacing: 3) {
                Text(badge.title)
                    .font(.studyQuest(.caption, weight: .bold))
                    .foregroundStyle(settings.primaryText)
                    .multilineTextAlignment(.center)
                Text(badge.subtitle)
                    .font(.studyQuest(.caption2, weight: .semibold))
                    .foregroundStyle(settings.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 136)
        .padding(12)
        .studyQuestCard(settings: settings, radius: AppTheme.fieldRadius)
        .accessibilityLabel(badge.isUnlocked ? badge.title : "\(badge.title) locked")
    }
}
