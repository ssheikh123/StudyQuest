import SwiftUI

struct RewardsSummaryCard: View {
    let level: Int
    let coins: Int
    let settings: AppAccessibilitySettings

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Rewards Summary", subtitle: "Your current inventory")

            HStack(spacing: 12) {
                SummaryMetric(title: "Level", value: "\(level)", iconName: "star.fill", color: AppTheme.primary, settings: settings)
                SummaryMetric(title: "Coins", value: "\(coins)", iconName: "circle.hexagongrid.fill", color: AppTheme.goldReward, settings: settings)
            }
        }
        .padding(18)
        .studyQuestCard(settings: settings)
    }
}

private struct SummaryMetric: View {
    let title: String
    let value: String
    let iconName: String
    let color: Color
    let settings: AppAccessibilitySettings

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: iconName)
                .font(.headline.weight(.bold))
                .foregroundStyle(color)
            Text(value)
                .font(.studyQuest(.title3, weight: .bold))
                .foregroundStyle(settings.primaryText)
            Text(title)
                .font(.studyQuest(.caption, weight: .semibold))
                .foregroundStyle(settings.secondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(color.opacity(0.11))
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.fieldRadius))
    }
}
