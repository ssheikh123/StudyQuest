import SwiftUI

struct WeeklyProgressCard: View {
    let weeklyProgress: WeeklyProgress
    let settings: AppAccessibilitySettings

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Weekly Progress")

            HStack(spacing: 12) {
                WeeklyMetricView(value: "\(weeklyProgress.lessonsCompleted)", title: "Lessons", iconName: "books.vertical.fill", settings: settings)
                WeeklyMetricView(value: "\(weeklyProgress.xpEarned)", title: "XP", iconName: "bolt.fill", settings: settings)
            }

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Weekly goal")
                    Spacer()
                    Text(weeklyProgress.goalText)
                }
                .font(.studyQuest(.subheadline, weight: .semibold))
                .foregroundStyle(settings.secondaryText)

                ProgressBar(value: weeklyProgress.goalProgress, tint: settings.accentColor, minimumFillWidth: 12)
                    .frame(height: 12)
            }
        }
        .padding(18)
        .studyQuestCard(settings: settings)
    }
}

private struct WeeklyMetricView: View {
    let value: String
    let title: String
    let iconName: String
    let settings: AppAccessibilitySettings

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: iconName)
                .font(.headline.weight(.bold))
                .foregroundStyle(settings.accentColor)
            Text(value)
                .font(.studyQuest(.title2, weight: .bold))
                .foregroundStyle(settings.primaryText)
            Text(title)
                .font(.studyQuest(.caption, weight: .semibold))
                .foregroundStyle(settings.secondaryText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(settings.accentColor.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.fieldRadius))
    }
}
