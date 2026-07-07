import SwiftUI

struct DailyRewardClaimCard: View {
    let canClaim: Bool
    let rewardCoins: Int
    let settings: AppAccessibilitySettings
    let claim: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 12) {
                Image(systemName: "calendar.badge.plus")
                    .font(.title.weight(.bold))
                    .foregroundStyle(AppTheme.goldReward)
                    .frame(width: 58, height: 58)
                    .background(AppTheme.goldReward.opacity(0.14))
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.fieldRadius))

                VStack(alignment: .leading, spacing: 4) {
                    Text("Daily Reward")
                        .font(.studyQuest(.title3, weight: .bold))
                        .foregroundStyle(settings.primaryText)
                    Text(canClaim ? "Claim \(rewardCoins) coins today." : "Reward claimed. Come back tomorrow.")
                        .font(.studyQuest(.subheadline, weight: .semibold))
                        .foregroundStyle(settings.secondaryText)
                }

                Spacer()
            }

            PrimaryButton(
                title: canClaim ? "Claim Coins" : "Claimed",
                iconName: canClaim ? "gift.fill" : "checkmark.seal.fill",
                color: canClaim ? AppTheme.goldReward : .secondary,
                action: claim
            )
            .disabled(!canClaim)
            .opacity(canClaim ? 1 : 0.65)
        }
        .padding(18)
        .studyQuestCard(settings: settings)
    }
}
