import SwiftUI

struct ContentView: View {
    @State private var appState = AppPersistenceService.load()
    @State private var selectedTab = AppTab.home
    @State private var activeLesson: Lesson?
    @State private var hasFinishedLaunch = false

    private var settings: AppAccessibilitySettings {
        appState.settings.accessibility
    }

    private var level: Int {
        appState.progress.level
    }

    var body: some View {
        ZStack {
            if hasFinishedLaunch {
                if appState.profile.hasCompletedOnboarding {
                    mainAppView
                        .transition(settings.reduceMotion ? .identity : .opacity)
                        .overlay(alignment: .topLeading) {
                            Button(action: returnToLaunchScreen) {
                                Image(systemName: "arrow.left")
                                    .font(.headline.weight(.bold))
                                    .frame(width: 44, height: 44)
                                    .background(.regularMaterial)
                                    .clipShape(Circle())
                            }
                            .accessibilityLabel("Back to launch screen")
                            .padding(.top, 8)
                            .padding(.leading, 12)
                        }
                } else {
                    OnboardingView(settings: settings, complete: completeOnboarding)
                        .transition(settings.reduceMotion ? .identity : .opacity)
                }
            } else {
                LaunchScreenView(
                    avatarColor: appState.profile.avatarColor,
                    avatarAccessory: appState.profile.avatarAccessory,
                    settings: settings,
                    start: startApp
                )
                .transition(settings.reduceMotion ? .identity : .opacity)
            }
        }
        .tint(settings.accentColor)
        .preferredColorScheme(settings.darkMode ? .dark : nil)
        .dynamicTypeSize(settings.largerText ? .accessibility2 : .large)
        .contrast(settings.highContrast ? 1.2 : 1.0)
        .transaction { transaction in
            if settings.reduceMotion {
                transaction.disablesAnimations = true
            }
        }
        .onAppear(perform: prepareDailyProgression)
        .sheet(item: $activeLesson) { lesson in
            LessonDetailView(
                lesson: lesson,
                isCompleted: appState.progress.lessonProgress.isCompleted(lesson),
                nextLesson: appState.progress.lessonProgress.nextLesson(after: lesson, in: CurriculumData.subjects),
                settings: settings,
                close: { activeLesson = nil },
                completeLesson: { completeLesson(lesson) },
                openNextLesson: { nextLesson in
                    appState.progress.lessonProgress.currentLessonID = nextLesson.id
                    activeLesson = nextLesson
                    saveAppState()
                }
            )
        }
    }

    private var mainAppView: some View {
        TabView(selection: $selectedTab) {
            HomeView(
                userName: appState.profile.userName,
                xp: appState.progress.xp,
                level: level,
                progress: appState.progress.lessonProgress,
                coins: appState.rewards.wallet.coins,
                avatarColor: appState.profile.avatarColor,
                avatarAccessory: appState.profile.avatarAccessory,
                questData: appState.rewards.quests,
                streakData: appState.rewards.streak,
                settings: settings,
                claimQuest: claimQuest,
                startLesson: startLesson,
                selectTab: { tab in selectedTab = tab }
            )
            .tabItem { Label(AppTab.home.title, systemImage: AppTab.home.iconName) }
            .tag(AppTab.home)

            LessonsHomeView(
                xp: appState.progress.xp,
                level: level,
                progress: appState.progress.lessonProgress,
                settings: settings,
                startLesson: startLesson
            )
            .tabItem { Label(AppTab.lessons.title, systemImage: AppTab.lessons.iconName) }
            .tag(AppTab.lessons)

            RewardsView(
                level: level,
                xp: appState.progress.xp,
                progress: appState.progress.lessonProgress,
                questData: appState.rewards.quests,
                streakData: appState.rewards.streak,
                settings: settings,
                wallet: rewardsWalletBinding,
                avatarColor: avatarColorBinding,
                avatarAccessory: avatarAccessoryBinding
            )
            .tabItem { Label(AppTab.rewards.title, systemImage: AppTab.rewards.iconName) }
            .tag(AppTab.rewards)

            ChatsView(settings: settings)
                .tabItem { Label(AppTab.chats.title, systemImage: AppTab.chats.iconName) }
                .tag(AppTab.chats)

            ProfileView(
                xp: appState.progress.xp,
                level: level,
                progress: appState.progress.lessonProgress,
                settings: settings,
                wallet: rewardsWalletBinding,
                avatarColor: avatarColorBinding,
                avatarAccessory: avatarAccessoryBinding,
                learningFocusSubjectID: learningFocusBinding,
                accessibilitySettings: accessibilitySettingsBinding,
                resetProfile: resetProfile
            )
            .tabItem { Label(AppTab.profile.title, systemImage: AppTab.profile.iconName) }
            .tag(AppTab.profile)
        }
        .toolbarBackground(.visible, for: .tabBar)
        .toolbarBackground(settings.cardBackground, for: .tabBar)
    }

    private var rewardsWalletBinding: Binding<RewardsWallet> {
        Binding(
            get: { appState.rewards.wallet },
            set: { wallet in
                appState.rewards.wallet = wallet
                saveAppState()
            }
        )
    }

    private var avatarColorBinding: Binding<AvatarColor> {
        Binding(
            get: { appState.profile.avatarColor },
            set: { color in
                appState.profile.avatarColor = color
                saveAppState()
            }
        )
    }

    private var avatarAccessoryBinding: Binding<AvatarAccessory> {
        Binding(
            get: { appState.profile.avatarAccessory },
            set: { accessory in
                appState.profile.avatarAccessory = accessory
                saveAppState()
            }
        )
    }

    private var learningFocusBinding: Binding<String> {
        Binding(
            get: { appState.profile.learningFocusSubjectID },
            set: { subjectID in
                appState.profile.learningFocusSubjectID = subjectID
                saveAppState()
            }
        )
    }

    private var accessibilitySettingsBinding: Binding<AppAccessibilitySettings> {
        Binding(
            get: { appState.settings.accessibility },
            set: { accessibilitySettings in
                appState.settings.accessibility = accessibilitySettings
                saveAppState()
            }
        )
    }

    private func prepareDailyProgression() {
        QuestManager.refreshDailyQuests(in: &appState.rewards.quests)
        appState.rewards.streak = StreakManager.normalized(appState.rewards.streak)
        saveAppState()
    }

    private func claimQuest(_ quest: DailyQuest) {
        var questData = appState.rewards.quests
        var xp = appState.progress.xp
        var wallet = appState.rewards.wallet

        if QuestManager.claim(
            quest,
            data: &questData,
            xp: &xp,
            wallet: &wallet
        ) {
            appState.rewards.quests = questData
            appState.progress.xp = xp
            appState.rewards.wallet = wallet
            saveAppState()
        }
    }

    private func startApp() {
        withAnimation(settings.reduceMotion ? nil : .easeInOut(duration: 0.35)) {
            hasFinishedLaunch = true
        }
    }

    private func returnToLaunchScreen() {
        activeLesson = nil

        withAnimation(settings.reduceMotion ? nil : .easeInOut(duration: 0.35)) {
            hasFinishedLaunch = false
        }
    }

    private func completeOnboarding(profile: UserProfile) {
        appState.profile = profile
        AvatarManager.grantStarterEquipment(profile: profile, wallet: &appState.rewards.wallet)
        selectedTab = .home
        saveAppState()
    }

    private func startLesson(_ lesson: Lesson) {
        appState.progress.lessonProgress.currentLessonID = lesson.id
        activeLesson = lesson
        saveAppState()
    }

    private func completeLesson(_ lesson: Lesson) {
        var progress = appState.progress.lessonProgress
        var xp = appState.progress.xp

        if LessonProgressService.complete(
            lesson,
            progress: &progress,
            xp: &xp,
            learningFocusSubjectID: appState.profile.learningFocusSubjectID
        ) {
            let xpEarned = xp - appState.progress.xp
            appState.progress.lessonProgress = progress
            appState.progress.xp = xp
            RewardsService.awardLessonCompletionCoins(
                for: lesson,
                wallet: &appState.rewards.wallet,
                learningFocusSubjectID: appState.profile.learningFocusSubjectID
            )
            QuestManager.recordLessonCompletion(
                lesson,
                xpEarned: xpEarned,
                questionsAnswered: lesson.quizQuestions.count,
                level: Leveling.level(for: xp),
                data: &appState.rewards.quests
            )
            if let streakReward = StreakManager.recordLessonCompletion(streak: &appState.rewards.streak) {
                appState.rewards.wallet.coins += streakReward.coins
                if let badgeID = streakReward.badgeID {
                    appState.rewards.unlockedBadgeIDs.insert(badgeID)
                }
                if let cosmeticItemID = streakReward.cosmeticItemID {
                    appState.rewards.wallet.purchasedShopItemIDs.insert(cosmeticItemID)
                }
            }
            appState.rewards.dailyStreak = appState.rewards.streak.currentStreak
            saveAppState()
        }
    }

    private func resetProfile() {
        activeLesson = nil
        selectedTab = .home
        appState = ProfileManager.resetLocalProfile()
        hasFinishedLaunch = true
    }

    private func saveAppState() {
        AppPersistenceService.save(appState)
    }
}

#Preview {
    ContentView()
}
