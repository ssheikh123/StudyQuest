import SwiftUI

struct HomeView: View {
    let userName: String
    let xp: Int
    let level: Int
    let progress: LessonProgress
    let coins: Int
    let avatarColor: AvatarColor
    let avatarAccessory: AvatarAccessory
    let questData: QuestData
    let streakData: StreakData
    let settings: AppAccessibilitySettings
    let claimQuest: (DailyQuest) -> Void
    let startLesson: (Lesson) -> Void
    let selectTab: (AppTab) -> Void

    @State private var quote = HomeDashboardData.sample.quotes.randomElement() ?? "Small progress each day adds up."
    @State private var activeAlert: HomeDashboardAlert?
    @State private var showsLearningAssistant = false
    @AppStorage("studyQuest.weeklyGoal.kind") private var weeklyGoalKindRaw = WeeklyGoalKind.lessons.rawValue
    @AppStorage("studyQuest.weeklyGoal.target") private var weeklyGoalTarget = 3
    @AppStorage("studyQuest.weeklyGoal.baselineLevel") private var weeklyGoalBaselineLevel = 1
    @AppStorage("studyQuest.weeklyGoal.baselineLessons") private var weeklyGoalBaselineLessons = 0
    @AppStorage("studyQuest.weeklyGoal.baselineXP") private var weeklyGoalBaselineXP = 0
    @AppStorage("studyQuest.weeklyGoal.week") private var weeklyGoalWeek = ""

    private let dashboardData = HomeDashboardData.sample

    private var currentLesson: Lesson? {
        progress.currentLesson(in: CurriculumData.subjects)
    }

    private var lessonProgress: Double {
        let totalLessons = CurriculumData.beginnerLessons.count
        guard totalLessons > 0 else { return 0 }
        return Double(progress.completedLessonIDs.count) / Double(totalLessons)
    }

    private var weeklyGoalKind: WeeklyGoalKind {
        WeeklyGoalKind(rawValue: weeklyGoalKindRaw) ?? .lessons
    }

    private var weeklyLessonsCompleted: Int {
        max(0, progress.completedLessonIDs.count - weeklyGoalBaselineLessons)
    }

    private var weeklyXPEarned: Int {
        max(0, xp - weeklyGoalBaselineXP)
    }

    private var weeklyGoalCompleted: Int {
        switch weeklyGoalKind {
        case .lessons:
            return weeklyLessonsCompleted
        case .levels:
            return max(0, level - weeklyGoalBaselineLevel)
        }
    }

    private var liveWeeklyProgress: WeeklyProgress {
        WeeklyProgress(lessonsCompleted: weeklyLessonsCompleted, xpEarned: weeklyXPEarned)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    DashboardHeader(
                        learnerName: userName,
                        level: level,
                        xpUntilNextLevel: Leveling.xpUntilNextLevel(for: xp),
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

                    StreakCard(
                        streak: streakData.currentStreak,
                        lastStudyDate: lastStudyDateText,
                        rewardProgress: min(Double(streakData.currentStreak % 7) / 7, 1),
                        message: StreakManager.message(for: streakData.currentStreak),
                        settings: settings
                    )

                    questsSection

                    SystemTipCard(message: "Complete another quest to keep your momentum going.", settings: settings)

                    WeeklyProgressCard(
                        weeklyProgress: liveWeeklyProgress,
                        goalKind: weeklyGoalKind,
                        goalTarget: weeklyGoalTarget,
                        goalCompleted: weeklyGoalCompleted,
                        settings: settings,
                        selectGoalKind: selectWeeklyGoalKind,
                        adjustGoalTarget: adjustWeeklyGoalTarget,
                        resetGoal: resetWeeklyGoalBaseline
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
            .sheet(isPresented: $showsLearningAssistant) {
                LearningAssistantView(context: currentLessonContext, settings: settings)
            }
            .onAppear(perform: refreshWeeklyGoalIfNeeded)
        }
    }

    private var currentLessonContext: LessonContext? {
        guard let currentLesson else { return nil }
        return LessonContext(lesson: currentLesson)
    }

    private var lastStudyDateText: String {
        guard let date = streakData.lastLessonCompletionDate else { return "Not started" }
        return Calendar.current.isDateInToday(date) ? "Today" : date.formatted(date: .abbreviated, time: .omitted)
    }

    private var questsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Today's Quests", subtitle: "Complete goals and claim rewards")

            ForEach(questData.quests) { quest in
                DailyQuestCard(quest: quest, settings: settings) {
                    claimQuest(quest)
                }
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
            QuickAction(id: "learning-assistant", title: "Learning Assistant", iconName: "graduationcap.fill", color: .indigo) {
                showsLearningAssistant = true
            },
            QuickAction(id: "rewards", title: "Rewards", iconName: "gift.fill", color: .orange) {
                selectTab(.rewards)
            },
            QuickAction(id: "chats", title: "Chats", iconName: "message.fill", color: .teal) {
                selectTab(.chats)
            }
        ]
    }

    private func selectWeeklyGoalKind(_ kind: WeeklyGoalKind) {
        weeklyGoalKindRaw = kind.rawValue
    }

    private func adjustWeeklyGoalTarget(by amount: Int) {
        weeklyGoalTarget = min(max(weeklyGoalTarget + amount, 1), 12)
    }

    private func refreshWeeklyGoalIfNeeded() {
        if weeklyGoalWeek != currentWeekIdentifier {
            resetWeeklyGoalBaseline()
        }
    }

    private func resetWeeklyGoalBaseline() {
        weeklyGoalWeek = currentWeekIdentifier
        weeklyGoalBaselineLevel = level
        weeklyGoalBaselineLessons = progress.completedLessonIDs.count
        weeklyGoalBaselineXP = xp
    }

    private var currentWeekIdentifier: String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())
        return "\(components.yearForWeekOfYear ?? 0)-\(components.weekOfYear ?? 0)"
    }
}

private enum HomeDashboardAlert: Identifiable {
    case notifications

    var id: String { "notifications" }
    var title: String { "Notifications" }
    var message: String { "Notifications are coming soon." }
}
