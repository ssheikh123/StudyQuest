import Foundation

struct RewardData: Codable, Equatable {
    var wallet = RewardsWallet()
    var unlockedBadgeIDs: Set<String> = []
    var dailyStreak = 0
}
