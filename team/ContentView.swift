import SwiftUI

struct ContentView: View {
    @State private var selectedTab = AppTab.home
    @State private var xp = 0
    @State private var completedLessonIDs = Set<String>()
    @State private var activeLesson: STEMLesson?
    @State private var avatarColor = AvatarColor.sky
    @State private var avatarAccessory = AvatarAccessory.stars
    @State private var accessibilitySettings = AppAccessibilitySettings()
    @State private var hasFinishedLaunch = false

    private var level: Int {
        Leveling.level(for: xp)
    }

    var body: some View {
        ZStack {
            if hasFinishedLaunch {
                mainAppView
                    .transition(accessibilitySettings.reduceMotion ? .identity : .opacity)
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
                LaunchScreenView(
                    avatarColor: avatarColor,
                    avatarAccessory: avatarAccessory,
                    settings: accessibilitySettings,
                    start: startApp
                )
                .transition(accessibilitySettings.reduceMotion ? .identity : .opacity)
            }
        }
        .tint(accessibilitySettings.accentColor)
        .preferredColorScheme(accessibilitySettings.darkMode ? .dark : nil)
        .dynamicTypeSize(accessibilitySettings.largerText ? .accessibility2 : .large)
        .contrast(accessibilitySettings.highContrast ? 1.2 : 1.0)
        .transaction { transaction in
            if accessibilitySettings.reduceMotion {
                transaction.disablesAnimations = true
            }
        }
        .sheet(item: $activeLesson) { lesson in
            LessonDetailView(
                lesson: lesson,
                isCompleted: completedLessonIDs.contains(lesson.id),
                settings: accessibilitySettings,
                close: { activeLesson = nil },
                completeLesson: {
                    LessonProgressService.complete(
                        lesson,
                        completedLessonIDs: &completedLessonIDs,
                        xp: &xp
                    )
                }
            )
        }
    }

    private var mainAppView: some View {
        TabView(selection: $selectedTab) {
            HomeView(settings: accessibilitySettings)
                .tabItem { Label(AppTab.home.title, systemImage: AppTab.home.iconName) }
                .tag(AppTab.home)

            LessonsHomeView(
                xp: xp,
                level: level,
                completedLessonIDs: completedLessonIDs,
                settings: accessibilitySettings,
                startLesson: { lesson in activeLesson = lesson }
            )
            .tabItem { Label(AppTab.lessons.title, systemImage: AppTab.lessons.iconName) }
            .tag(AppTab.lessons)

            RewardsView(settings: accessibilitySettings)
                .tabItem { Label(AppTab.rewards.title, systemImage: AppTab.rewards.iconName) }
                .tag(AppTab.rewards)

            ChatsView(settings: accessibilitySettings)
                .tabItem { Label(AppTab.chats.title, systemImage: AppTab.chats.iconName) }
                .tag(AppTab.chats)

            ProfileView(
                xp: xp,
                level: level,
                completedLessonIDs: completedLessonIDs,
                settings: accessibilitySettings,
                avatarColor: $avatarColor,
                avatarAccessory: $avatarAccessory,
                accessibilitySettings: $accessibilitySettings
            )
            .tabItem { Label(AppTab.profile.title, systemImage: AppTab.profile.iconName) }
            .tag(AppTab.profile)
        }
    }

    private func startApp() {
        withAnimation(accessibilitySettings.reduceMotion ? nil : .easeInOut(duration: 0.35)) {
            hasFinishedLaunch = true
        }
    }

    private func returnToLaunchScreen() {
        activeLesson = nil

        withAnimation(accessibilitySettings.reduceMotion ? nil : .easeInOut(duration: 0.35)) {
            hasFinishedLaunch = false
        }
    }
}

#Preview {
    ContentView()
}
