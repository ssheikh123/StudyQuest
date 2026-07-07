import SwiftUI

struct RewardCard: View {
    let title: String
    let subtitle: String
    let iconName: String
    let color: Color
    let settings: AppAccessibilitySettings

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: iconName)
                .font(.title.weight(.bold))
                .foregroundStyle(color)
                .frame(width: 58, height: 58)
                .background(color.opacity(0.14))
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.fieldRadius))

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.studyQuest(.headline, weight: .bold))
                    .foregroundStyle(settings.primaryText)
                Text(subtitle)
                    .font(.studyQuest(.subheadline, weight: .semibold))
                    .foregroundStyle(settings.secondaryText)
            }

            Spacer()
        }
        .padding(18)
        .studyQuestCard(settings: settings)
    }
}
