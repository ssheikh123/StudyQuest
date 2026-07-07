import SwiftUI

struct DailyChallengeCard: View {
    let challenge: DailyChallenge
    let settings: AppAccessibilitySettings

    private var challengeColor: Color {
        challenge.isComplete ? AppTheme.greenSuccess : AppTheme.coral
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                Image(systemName: challenge.isComplete ? "checkmark.seal.fill" : "target")
                    .font(.title.weight(.bold))
                    .foregroundStyle(challengeColor)
                    .frame(width: 58, height: 58)
                    .background(challengeColor.opacity(0.14))
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.fieldRadius))

                VStack(alignment: .leading, spacing: 4) {
                    Text("Daily Challenge")
                        .font(.studyQuest(.caption, weight: .bold))
                        .textCase(.uppercase)
                        .foregroundStyle(settings.secondaryText)
                    Text(challenge.title)
                        .font(.studyQuest(.title3, weight: .bold))
                        .foregroundStyle(settings.primaryText)
                }

                Spacer()
            }

            ProgressBar(value: challenge.progress, tint: challengeColor, minimumFillWidth: 12)
                .frame(height: 12)

            HStack {
                Text(challenge.progressText)
                    .font(.studyQuest(.subheadline, weight: .semibold))
                    .foregroundStyle(settings.secondaryText)
                Spacer()
                Label(challenge.rewardText, systemImage: "gift.fill")
                    .font(.studyQuest(.subheadline, weight: .bold))
                    .foregroundStyle(challengeColor)
            }
        }
        .padding(18)
        .studyQuestCard(settings: settings)
    }
}
