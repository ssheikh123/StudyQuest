import Foundation

struct HomeDashboardData {
    let learnerName: String
    let coins: Int
    let currentStreak: Int
    let lastStudyDate: String
    let streakRewardProgress: Double
    let streakMessage: String
    let dailyChallenge: DailyChallenge
    let weeklyProgress: WeeklyProgress
    let recommendedLessons: [RecommendedLesson]
    let quotes: [String]

    static let sample = HomeDashboardData(
        learnerName: "Alex",
        coins: 420,
        currentStreak: 7,
        lastStudyDate: "Today",
        streakRewardProgress: 0.7,
        streakMessage: "One more focused session keeps your streak strong.",
        dailyChallenge: DailyChallenge(
            title: "Complete 2 lessons",
            progressText: "1 of 2 lessons",
            progress: 0.5,
            rewardText: "+25 Coins",
            isComplete: false
        ),
        weeklyProgress: WeeklyProgress(
            lessonsCompleted: 4,
            xpEarned: 160,
            goalText: "4 of 6 lessons",
            goalProgress: 0.67
        ),
        recommendedLessons: [
            RecommendedLesson(lessonID: "algebra-variables-expressions", difficulty: "Beginner", estimatedTime: "5 min"),
            RecommendedLesson(lessonID: "reading-main-idea", difficulty: "Beginner", estimatedTime: "5 min"),
            RecommendedLesson(lessonID: "biology-cells", difficulty: "Beginner", estimatedTime: "5 min"),
            RecommendedLesson(lessonID: "programming-variables", difficulty: "Beginner", estimatedTime: "5 min")
        ],
        quotes: [
            "Small progress each day adds up.",
            "Learning is leveling up your future.",
            "Every question answered builds momentum.",
            "Curiosity turns practice into progress."
        ]
    )
}

struct DailyChallenge {
    let title: String
    let progressText: String
    let progress: Double
    let rewardText: String
    let isComplete: Bool
}

struct WeeklyProgress {
    let lessonsCompleted: Int
    let xpEarned: Int
    let goalText: String
    let goalProgress: Double
}

struct RecommendedLesson: Identifiable {
    let lessonID: String
    let difficulty: String
    let estimatedTime: String

    var id: String { lessonID }
}
