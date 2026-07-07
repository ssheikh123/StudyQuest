import SwiftUI

struct HomeView: View {
    let userName: String
    let xp: Int
    let level: Int
    let progress: LessonProgress
    let coins: Int
    let avatarColor: AvatarColor
    let avatarAccessory: AvatarAccessory
    let settings: AppAccessibilitySettings
    let startLesson: (Lesson) -> Void
    let selectTab: (AppTab) -> Void

    @State private var quote = HomeDashboardData.sample.quotes.randomElement() ?? "Small progress each day adds up."
    @State private var activeAlert: HomeDashboardAlert?

    private let dashboardData = HomeDashboardData.sample

    private var currentLesson: Lesson? {
        progress.currentLesson(in: CurriculumData.subjects)
    }

    private var lessonProgress: Double {
        let totalLessons = CurriculumData.beginnerLessons.count
        guard totalLessons > 0 else { return 0 }
        return Double(progress.completedLessonIDs.count) / Double(totalLessons)
    }

    private var recommendedLessons: [(metadata: RecommendedLesson, lesson: Lesson)] {
        dashboardData.recommendedLessons.compactMap { metadata in
            guard let lesson = CurriculumData.lesson(withID: metadata.lessonID) else { return nil }
            return (metadata, lesson)
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    DashboardHeader(
                        learnerName: userName,
                        level: level,
                        xp: xp,
                        coins: coins,
                        avatarColor: avatarColor,
                        avatarAccessory: avatarAccessory,
                        settings: settings,
                        notificationAction: { activeAlert = .notifications }
                    )

                    if let currentLesson {
                        ContinueLearningCard(
                            lesson: currentLesson,
                            progress: lessonProgress,
                            settings: settings,
                            action: { startLesson(currentLesson) }
                        )
                    }

                    ViewThatFits(in: .horizontal) {
                        HStack(alignment: .top, spacing: 12) {
                            StreakCard(
                                streak: dashboardData.currentStreak,
                                lastStudyDate: dashboardData.lastStudyDate,
                                rewardProgress: dashboardData.streakRewardProgress,
                                message: dashboardData.streakMessage,
                                settings: settings
                            )

                            DailyChallengeCard(
                                challenge: dashboardData.dailyChallenge,
                                settings: settings
                            )
                        }

                        VStack(spacing: 12) {
                            StreakCard(
                                streak: dashboardData.currentStreak,
                                lastStudyDate: dashboardData.lastStudyDate,
                                rewardProgress: dashboardData.streakRewardProgress,
                                message: dashboardData.streakMessage,
                                settings: settings
                            )

                            DailyChallengeCard(
                                challenge: dashboardData.dailyChallenge,
                                settings: settings
                            )
                        }
                    }

                    SparkTipCard(message: "You've got this. One lesson today keeps your adventure moving.", settings: settings)

                    recommendedSection

                    WeeklyProgressCard(
                        weeklyProgress: dashboardData.weeklyProgress,
                        settings: settings
                    )

                    QuickActionGrid(actions: quickActions, settings: settings)

                    QuoteCard(quote: quote, settings: settings)
                }
                .padding(.horizontal, 18)
                .padding(.top, 10)
                .padding(.bottom, 28)
            }
            .background(settings.screenBackground)
            .navigationTitle("Home")
            .alert(item: $activeAlert) { alert in
                Alert(
                    title: Text(alert.title),
                    message: Text(alert.message),
                    dismissButton: .default(Text("OK"))
                )
            }
            .animation(settings.reduceMotion ? nil : .easeInOut(duration: 0.25), value: progress.completedLessonIDs.count)
        }
    }

    private var recommendedSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(
                title: "Recommended Lessons",
                subtitle: "Pick your next adventure",
                actionTitle: "See All",
                action: { selectTab(.lessons) }
            )

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(recommendedLessons, id: \.metadata.id) { item in
                        RecommendedLessonCard(
                            lesson: item.lesson,
                            difficulty: item.metadata.difficulty,
                            estimatedTime: item.metadata.estimatedTime,
                            settings: settings,
                            action: { startLesson(item.lesson) }
                        )
                    }
                }
                .padding(.vertical, 4)
            }
        }
    }

    private var quickActions: [QuickAction] {
        [
            QuickAction(id: "resume", title: "Resume Lesson", iconName: "play.fill", color: .green) {
                if let currentLesson {
                    startLesson(currentLesson)
                }
            },
            QuickAction(id: "browse", title: "Browse Lessons", iconName: "book.closed.fill", color: settings.accentColor) {
                selectTab(.lessons)
            },
            QuickAction(id: "ask-ai", title: "Ask AI", iconName: "sparkles", color: .indigo) {
                activeAlert = .aiTutor
            },
            QuickAction(id: "rewards", title: "Rewards", iconName: "gift.fill", color: .orange) {
                selectTab(.rewards)
            },
            QuickAction(id: "chats", title: "Chats", iconName: "message.fill", color: .teal) {
                selectTab(.chats)
            }
        ]
    }
}

private enum HomeDashboardAlert: Identifiable {
    case notifications
    case aiTutor

    var id: String {
        switch self {
        case .notifications:
            return "notifications"
        case .aiTutor:
            return "aiTutor"
        }
    }

    var title: String {
        switch self {
        case .notifications:
            return "Notifications"
        case .aiTutor:
            return "Ask AI"
        }
    }

    var message: String {
        switch self {
        case .notifications:
            return "Notifications are coming soon."
        case .aiTutor:
            return "AI Tutor is coming soon."
        }
    }
}
