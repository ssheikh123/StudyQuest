import SwiftUI

struct RewardsView: View {
    let level: Int
    let xp: Int
    let progress: LessonProgress
    let questData: QuestData
    let streakData: StreakData
    let settings: AppAccessibilitySettings
    @Binding var wallet: RewardsWallet
    @Binding var avatarColor: AvatarColor
    @Binding var avatarAccessory: AvatarAccessory

    @State private var message: RewardsMessage?

    private let badgeColumns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    RewardsSummaryCard(level: level, xp: xp, coins: wallet.coins, settings: settings)

                    RewardCard(
                        title: "Player Progress",
                        subtitle: "\(progress.completedLessonIDs.count) lessons complete • \(streakData.currentStreak) day streak",
                        iconName: "chart.line.uptrend.xyaxis",
                        color: settings.accentColor,
                        settings: settings
                    )

                    DailyRewardClaimCard(
                        canClaim: wallet.canClaimDailyReward(),
                        rewardCoins: RewardsCatalog.dailyRewardCoins,
                        settings: settings,
                        claim: claimDailyReward
                    )

                    questsPreviewSection
                    badgesSection
                    shopSection
                    futureRewardsSection
                }
                .padding(18)
            }
            .background(settings.screenBackground)
            .navigationTitle("Rewards")
            .alert(item: $message) { message in
                Alert(
                    title: Text(message.title),
                    message: Text(message.body),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }

    private var questsPreviewSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(title: "Daily Quests", subtitle: "Claim quest rewards from Home")
            ForEach(questData.quests) { quest in
                DailyQuestCard(quest: quest, settings: settings) { }
            }
        }
    }

    private var shopSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(title: "Avatar Shop", subtitle: "Spend coins on Spark-approved gear")

            ForEach(ShopCategory.allCases) { category in
                VStack(alignment: .leading, spacing: 10) {
                    Label(category.rawValue, systemImage: category.iconName)
                        .font(.studyQuest(.headline, weight: .bold))
                        .foregroundStyle(settings.primaryText)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(RewardsCatalog.shopItems.filter { $0.category == category }) { item in
                                ShopItemCard(
                                    item: item,
                                    isOwned: wallet.owns(item),
                                    canAfford: wallet.coins >= item.cost,
                                    settings: settings,
                                    purchase: { purchase(item) }
                                )
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
    }

    private var badgesSection: some View {
        let badges = RewardsCatalog.badges(progress: progress, xp: xp, level: level, streak: streakData)
        let earned = badges.filter(\.isUnlocked)
        let locked = badges.filter { !$0.isUnlocked }

        return VStack(alignment: .leading, spacing: 14) {
            SectionHeader(title: "Earned Badges", subtitle: "Milestones you've unlocked")
            LazyVGrid(columns: badgeColumns, spacing: 12) {
                ForEach(earned) { badge in
                    RewardBadgeCard(badge: badge, settings: settings)
                }
            }

            SectionHeader(title: "Locked Badges", subtitle: "Keep learning to unlock these")
            LazyVGrid(columns: badgeColumns, spacing: 12) {
                ForEach(locked) { badge in
                    RewardBadgeCard(badge: badge, settings: settings)
                }
            }
        }
    }

    private var futureRewardsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(title: "Coming Soon", subtitle: "Future versions of StudyQuest may allow points to be redeemed for real rewards.")

            ForEach(RewardsCatalog.futureRewards) { reward in
                FutureRewardCard(reward: reward, settings: settings)
            }
        }
    }

    private func claimDailyReward() {
        if RewardsService.claimDailyReward(wallet: &wallet) {
            message = RewardsMessage(title: "Daily Reward Claimed", body: "+\(RewardsCatalog.dailyRewardCoins) coins added to your wallet.")
        } else {
            message = RewardsMessage(title: "Already Claimed", body: "Come back tomorrow for another daily reward.")
        }
    }

    private func purchase(_ item: ShopItem) {
        switch RewardsService.purchase(item, wallet: &wallet) {
        case .purchased:
            applyCosmetic(item)
            message = RewardsMessage(title: "Purchased", body: "\(item.title) is now in your inventory.")
        case .alreadyOwned:
            applyCosmetic(item)
            message = RewardsMessage(title: "Already Owned", body: "\(item.title) is already available.")
        case .insufficientCoins:
            message = RewardsMessage(title: "Not Enough Coins", body: "Complete lessons or claim daily rewards to earn more coins.")
        }
    }

    private func applyCosmetic(_ item: ShopItem) {
        if let newColor = item.avatarColor {
            avatarColor = newColor
        }

        if let newAccessory = item.avatarAccessory {
            avatarAccessory = newAccessory
        }
    }
}

private struct RewardsMessage: Identifiable {
    let id = UUID()
    let title: String
    let body: String
}
