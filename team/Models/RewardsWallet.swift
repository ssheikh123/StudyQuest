import Foundation

struct RewardsWallet: Codable, Equatable {
    var coins = 120
    var purchasedShopItemIDs: Set<String> = []
    var lastDailyRewardClaimDate: Date?

    func owns(_ item: ShopItem) -> Bool {
        purchasedShopItemIDs.contains(item.id)
    }

    func canClaimDailyReward(today: Date = Date()) -> Bool {
        guard let lastDailyRewardClaimDate else { return true }
        return !Calendar.current.isDate(lastDailyRewardClaimDate, inSameDayAs: today)
    }
}
