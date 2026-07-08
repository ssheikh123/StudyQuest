import Foundation

enum StreakManager {
    struct StreakReward {
        let coins: Int
        let badgeID: String?
        let cosmeticItemID: String?
        let message: String
    }

    static func normalized(_ streak: StreakData, today: Date = Date()) -> StreakData {
        var streak = streak
        guard let lastDate = streak.lastLessonCompletionDate else { return streak }
        if Calendar.current.dateComponents([.day], from: Calendar.current.startOfDay(for: lastDate), to: Calendar.current.startOfDay(for: today)).day ?? 0 > 1 {
            streak.currentStreak = 0
        }
        return streak
    }

    static func recordLessonCompletion(streak: inout StreakData, today: Date = Date()) -> StreakReward? {
        let calendar = Calendar.current

        if let lastDate = streak.lastLessonCompletionDate {
            if calendar.isDate(lastDate, inSameDayAs: today) {
                return nil
            }

            let daysBetween = calendar.dateComponents([.day], from: calendar.startOfDay(for: lastDate), to: calendar.startOfDay(for: today)).day ?? 0
            streak.currentStreak = daysBetween == 1 ? streak.currentStreak + 1 : 1
        } else {
            streak.currentStreak = 1
        }

        streak.lastLessonCompletionDate = today
        streak.longestStreak = max(streak.longestStreak, streak.currentStreak)
        return reward(for: streak.currentStreak, awardedMilestones: &streak.awardedMilestones)
    }

    static func message(for streak: Int) -> String {
        switch streak {
        case 0:
            return "Let's start your learning journey!"
        case 1..<7:
            return "You're doing great!"
        case 7..<30:
            return "A whole week! Amazing!"
        default:
            return "You're unstoppable!"
        }
    }

    private static func reward(for day: Int, awardedMilestones: inout Set<Int>) -> StreakReward? {
        let coins: Int
        switch day {
        case 1:
            coins = 10
        case 3:
            coins = 20
        case 7:
            coins = 50
        case 14:
            coins = 75
        case 30:
            coins = 150
        default:
            return nil
        }

        guard !awardedMilestones.contains(day) else { return nil }
        awardedMilestones.insert(day)
        return StreakReward(
            coins: coins,
            badgeID: day == 14 ? "two-week-streak" : nil,
            cosmeticItemID: day == 30 ? "hat-star" : nil,
            message: "\(day)-day streak reward: +\(coins) coins"
        )
    }
}
