import SwiftUI

struct FutureRewardCard: View {
    let reward: FutureReward
    let settings: AppAccessibilitySettings

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: reward.iconName)
                .font(.title.weight(.bold))
                .foregroundStyle(reward.color)
                .frame(width: 56, height: 56)
                .background(reward.color.opacity(0.14))
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.fieldRadius))

            VStack(alignment: .leading, spacing: 4) {
                Text(reward.title)
                    .font(.studyQuest(.headline, weight: .bold))
                    .foregroundStyle(settings.primaryText)
                Text("Unlocks at Level \(reward.levelRequirement)")
                    .font(.studyQuest(.subheadline, weight: .semibold))
                    .foregroundStyle(settings.secondaryText)
            }

            Spacer()

            Text("Soon")
                .font(.studyQuest(.caption, weight: .bold))
                .foregroundStyle(.secondary)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color.secondary.opacity(0.12))
                .clipShape(Capsule())
        }
        .padding(16)
        .studyQuestCard(settings: settings)
    }
}
