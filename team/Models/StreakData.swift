import Foundation

struct StreakData: Codable, Equatable {
    var currentStreak = 0
    var longestStreak = 0
    var lastLessonCompletionDate: Date?
    var awardedMilestones: Set<Int> = []
}
