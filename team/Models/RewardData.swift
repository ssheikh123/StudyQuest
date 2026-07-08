import Foundation

struct RewardData: Codable, Equatable {
    var wallet = RewardsWallet()
    var unlockedBadgeIDs: Set<String> = []
    var dailyStreak = 0
    var quests = QuestData()
    var streak = StreakData()

    enum CodingKeys: String, CodingKey {
        case wallet
        case unlockedBadgeIDs
        case dailyStreak
        case quests
        case streak
    }

    init() { }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        wallet = try container.decodeIfPresent(RewardsWallet.self, forKey: .wallet) ?? RewardsWallet()
        unlockedBadgeIDs = try container.decodeIfPresent(Set<String>.self, forKey: .unlockedBadgeIDs) ?? []
        dailyStreak = try container.decodeIfPresent(Int.self, forKey: .dailyStreak) ?? 0
        quests = try container.decodeIfPresent(QuestData.self, forKey: .quests) ?? QuestData()
        streak = try container.decodeIfPresent(StreakData.self, forKey: .streak) ?? StreakData()
    }
}
