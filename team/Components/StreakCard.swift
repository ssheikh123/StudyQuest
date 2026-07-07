import SwiftUI

struct StreakCard: View {
    let streak: Int
    let lastStudyDate: String
    let rewardProgress: Double
    let message: String
    let settings: AppAccessibilitySettings

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                Image(systemName: "flame.fill")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundStyle(AppTheme.coral)
                    .frame(width: 58, height: 58)
                    .background(AppTheme.coral.opacity(0.14))
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.fieldRadius))

                VStack(alignment: .leading, spacing: 3) {
                    Text("\(streak) Day Streak")
                        .font(.studyQuest(.title3, weight: .bold))
                        .foregroundStyle(settings.primaryText)
                    Text("Last studied: \(lastStudyDate)")
                        .font(.studyQuest(.subheadline, weight: .semibold))
                        .foregroundStyle(settings.secondaryText)
                }

                Spacer()
            }

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Next reward")
                    Spacer()
                    Text("\(Int(rewardProgress * 100))%")
                }
                .font(.studyQuest(.caption, weight: .bold))
                .foregroundStyle(settings.secondaryText)

                ProgressBar(value: rewardProgress, tint: AppTheme.coral, minimumFillWidth: 12)
                    .frame(height: 12)
            }

            Text(message)
                .font(.studyQuest(.callout, weight: .semibold))
                .foregroundStyle(settings.secondaryText)
        }
        .padding(18)
        .studyQuestCard(settings: settings)
    }
}
