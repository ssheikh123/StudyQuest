import SwiftUI

struct AvatarCosmeticCard: View {
    let cosmetic: AvatarCosmetic
    let settings: AppAccessibilitySettings
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 10) {
                ZStack(alignment: .topTrailing) {
                    Image(systemName: cosmetic.unlocked ? cosmetic.icon : "lock.fill")
                        .font(.title2.weight(.bold))
                        .foregroundStyle(cosmetic.unlocked ? cosmetic.color : .secondary)
                        .frame(width: 52, height: 52)
                        .background((cosmetic.unlocked ? cosmetic.color : Color.secondary).opacity(0.14))
                        .clipShape(RoundedRectangle(cornerRadius: AppTheme.fieldRadius))

                    if cosmetic.equipped {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(AppTheme.greenSuccess)
                            .background(Circle().fill(settings.cardBackground))
                    }
                }

                Text(cosmetic.name)
                    .font(.studyQuest(.subheadline, weight: .bold))
                    .foregroundStyle(settings.primaryText)
                    .lineLimit(2)

                Text(statusText)
                    .font(.studyQuest(.caption, weight: .semibold))
                    .foregroundStyle(statusColor)
            }
            .frame(maxWidth: .infinity, minHeight: 132, alignment: .leading)
            .padding(14)
            .studyQuestCard(settings: settings, radius: AppTheme.fieldRadius)
            .opacity(cosmetic.unlocked ? 1 : 0.62)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(cosmetic.name), \(statusText)")
    }

    private var statusText: String {
        if cosmetic.equipped { return "Equipped" }
        if cosmetic.unlocked { return "Unlocked" }
        return "\(cosmetic.coinCost) coins"
    }

    private var statusColor: Color {
        if cosmetic.equipped { return AppTheme.greenSuccess }
        if cosmetic.unlocked { return settings.secondaryText }
        return AppTheme.goldReward
    }
}
