import Foundation

enum RewardsService {
    enum PurchaseResult {
        case purchased
        case alreadyOwned
        case insufficientCoins
    }

    static func claimDailyReward(wallet: inout RewardsWallet, today: Date = Date()) -> Bool {
        guard wallet.canClaimDailyReward(today: today) else { return false }
        wallet.coins += RewardsCatalog.dailyRewardCoins
        wallet.lastDailyRewardClaimDate = today
        return true
    }

    static func purchase(_ item: ShopItem, wallet: inout RewardsWallet) -> PurchaseResult {
        if wallet.owns(item) {
            return .alreadyOwned
        }

        guard wallet.coins >= item.cost else {
            return .insufficientCoins
        }

        wallet.coins -= item.cost
        wallet.purchasedShopItemIDs.insert(item.id)
        return .purchased
    }

    static func awardLessonCompletionCoins(for lesson: Lesson, wallet: inout RewardsWallet, learningFocusSubjectID: String?) {
        wallet.coins += coinReward(for: lesson, learningFocusSubjectID: learningFocusSubjectID)
    }

    static func coinReward(for lesson: Lesson, learningFocusSubjectID: String?) -> Int {
        RewardsCatalog.lessonCompletionCoins + (lesson.subjectID == learningFocusSubjectID ? 5 : 0)
    }
}
