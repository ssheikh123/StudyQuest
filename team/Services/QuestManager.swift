import Foundation

enum QuestManager {
    static func refreshDailyQuests(in data: inout QuestData, today: Date = Date()) {
        if let generatedDate = data.generatedDate,
           Calendar.current.isDate(generatedDate, inSameDayAs: today),
           data.quests.count == 3 {
            return
        }

        data.generatedDate = today
        data.quests = Array(questPool.shuffled().prefix(3))
    }

    static func recordLessonCompletion(_ lesson: Lesson, xpEarned: Int, questionsAnswered: Int, level: Int, data: inout QuestData) {
        for index in data.quests.indices {
            switch data.quests[index].kind {
            case .completeLessons:
                incrementQuest(at: index, by: 1, data: &data)
            case .earnXP:
                incrementQuest(at: index, by: xpEarned, data: &data)
            case .answerQuestions:
                incrementQuest(at: index, by: questionsAnswered, data: &data)
            case .completeSubjectLesson:
                if data.quests[index].subjectID == lesson.subjectID {
                    incrementQuest(at: index, by: 1, data: &data)
                }
            case .reachLevel:
                data.quests[index].progress = max(data.quests[index].progress, level)
                data.quests[index].completed = data.quests[index].progress >= data.quests[index].goal
            case .earnBadge:
                break
            }
        }
    }

    static func claim(_ quest: DailyQuest, data: inout QuestData, xp: inout Int, wallet: inout RewardsWallet) -> Bool {
        guard let index = data.quests.firstIndex(where: { $0.id == quest.id }),
              data.quests[index].completed,
              !data.quests[index].claimed else { return false }

        data.quests[index].claimed = true
        xp += data.quests[index].rewardXP
        wallet.coins += data.quests[index].rewardCoins
        return true
    }

    private static func incrementQuest(at index: Int, by amount: Int, data: inout QuestData) {
        data.quests[index].progress = min(data.quests[index].goal, data.quests[index].progress + amount)
        data.quests[index].completed = data.quests[index].progress >= data.quests[index].goal
    }

    private static let questPool: [DailyQuest] = [
        DailyQuest(id: "complete-1-lesson", kind: .completeLessons, subjectID: nil, title: "Complete 1 Lesson", description: "Finish any lesson today.", progress: 0, goal: 1, rewardXP: 40, rewardCoins: 15, completed: false, claimed: false),
        DailyQuest(id: "complete-2-lessons", kind: .completeLessons, subjectID: nil, title: "Complete 2 Lessons", description: "Finish two lessons today.", progress: 0, goal: 2, rewardXP: 75, rewardCoins: 25, completed: false, claimed: false),
        DailyQuest(id: "earn-100-xp", kind: .earnXP, subjectID: nil, title: "Earn 100 XP", description: "Collect XP from lessons or quests.", progress: 0, goal: 100, rewardXP: 30, rewardCoins: 20, completed: false, claimed: false),
        DailyQuest(id: "earn-200-xp", kind: .earnXP, subjectID: nil, title: "Earn 200 XP", description: "Push your XP higher today.", progress: 0, goal: 200, rewardXP: 50, rewardCoins: 30, completed: false, claimed: false),
        DailyQuest(id: "answer-10-questions", kind: .answerQuestions, subjectID: nil, title: "Answer 10 Questions", description: "Complete quiz questions in lessons.", progress: 0, goal: 10, rewardXP: 45, rewardCoins: 20, completed: false, claimed: false),
        DailyQuest(id: "algebra-lesson", kind: .completeSubjectLesson, subjectID: "algebra", title: "Complete Algebra", description: "Finish one Algebra lesson.", progress: 0, goal: 1, rewardXP: 40, rewardCoins: 20, completed: false, claimed: false),
        DailyQuest(id: "reading-lesson", kind: .completeSubjectLesson, subjectID: "reading", title: "Complete Reading", description: "Finish one Reading lesson.", progress: 0, goal: 1, rewardXP: 40, rewardCoins: 20, completed: false, claimed: false),
        DailyQuest(id: "biology-lesson", kind: .completeSubjectLesson, subjectID: "biology", title: "Complete Biology", description: "Finish one Biology lesson.", progress: 0, goal: 1, rewardXP: 40, rewardCoins: 20, completed: false, claimed: false),
        DailyQuest(id: "programming-lesson", kind: .completeSubjectLesson, subjectID: "programming-fundamentals", title: "Complete Programming", description: "Finish one Programming lesson.", progress: 0, goal: 1, rewardXP: 40, rewardCoins: 20, completed: false, claimed: false),
        DailyQuest(id: "reach-level-5", kind: .reachLevel, subjectID: nil, title: "Reach Level 5", description: "Level up your profile.", progress: 1, goal: 5, rewardXP: 100, rewardCoins: 50, completed: false, claimed: false)
    ]
}
