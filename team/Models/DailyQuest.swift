import Foundation

enum QuestKind: String, Codable, CaseIterable {
    case completeLessons
    case earnXP
    case answerQuestions
    case completeSubjectLesson
    case reachLevel
    case earnBadge
}

struct DailyQuest: Identifiable, Codable, Equatable {
    let id: String
    let kind: QuestKind
    let subjectID: String?
    let title: String
    let description: String
    var progress: Int
    let goal: Int
    let rewardXP: Int
    let rewardCoins: Int
    var completed: Bool
    var claimed: Bool

    var progressFraction: Double {
        guard goal > 0 else { return 0 }
        return min(Double(progress) / Double(goal), 1)
    }
}

struct QuestData: Codable, Equatable {
    var quests: [DailyQuest] = []
    var generatedDate: Date?
}
