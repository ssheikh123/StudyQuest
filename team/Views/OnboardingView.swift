import SwiftUI

struct OnboardingView: View {
    let settings: AppAccessibilitySettings
    let complete: (UserProfile) -> Void

    @State private var step = 0
    @State private var profile = UserProfile()
    @State private var draftName = ""

    private var canContinueName: Bool {
        !draftName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        ZStack {
            settings.screenBackground.ignoresSafeArea()

            VStack(spacing: 20) {
                progressDots

                TabView(selection: $step) {
                    welcomeStep.tag(0)
                    nameStep.tag(1)
                    focusStep.tag(2)
                    avatarStep.tag(3)
                    meetSparkStep.tag(4)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(settings.reduceMotion ? nil : .easeInOut(duration: 0.25), value: step)
            }
            .padding(20)
        }
    }

    private var progressDots: some View {
        HStack(spacing: 8) {
            ForEach(0..<5, id: \.self) { index in
                Capsule()
                    .fill(index == step ? settings.accentColor : Color.secondary.opacity(0.25))
                    .frame(width: index == step ? 28 : 8, height: 8)
            }
        }
        .padding(.top, 8)
    }

    private var welcomeStep: some View {
        onboardingCard {
            SparkBadge(size: 88)
            Text("Welcome to StudyQuest")
                .font(.studyQuest(.largeTitle, weight: .bold))
                .foregroundStyle(settings.primaryText)
                .multilineTextAlignment(.center)
            Text("A playful learning adventure where lessons earn XP, coins, badges, and avatar rewards.")
                .font(.studyQuest(.headline, weight: .semibold))
                .foregroundStyle(settings.secondaryText)
                .multilineTextAlignment(.center)
            SparkTipCard(message: "Hi! I'm Spark! Let's get your learning adventure started.", settings: settings)
            PrimaryButton(title: "Get Started", iconName: "arrow.right.circle.fill", color: settings.accentColor) {
                step = 1
            }
        }
    }

    private var nameStep: some View {
        onboardingCard {
            SparkBadge(size: 72)
            Text("What should Spark call you?")
                .font(.studyQuest(.title, weight: .bold))
                .foregroundStyle(settings.primaryText)
                .multilineTextAlignment(.center)
            TextField("Your name", text: $draftName)
                .font(.studyQuest(.title3, weight: .semibold))
                .textInputAutocapitalization(.words)
                .padding(16)
                .background(settings.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.fieldRadius))
            PrimaryButton(title: "Continue", iconName: "arrow.right", color: settings.accentColor) {
                profile.userName = draftName.trimmingCharacters(in: .whitespacesAndNewlines)
                step = 2
            }
            .disabled(!canContinueName)
            .opacity(canContinueName ? 1 : 0.55)
        }
    }

    private var focusStep: some View {
        onboardingCard(alignment: .leading) {
            Text("What would you like to focus on first?")
                .font(.studyQuest(.title, weight: .bold))
                .foregroundStyle(settings.primaryText)
            Text("You'll earn a small bonus while studying this subject.")
                .font(.studyQuest(.headline, weight: .semibold))
                .foregroundStyle(settings.secondaryText)

            VStack(spacing: 12) {
                ForEach(CurriculumData.subjects) { subject in
                    LearningFocusCard(
                        subject: subject,
                        isSelected: profile.learningFocusSubjectID == subject.id,
                        settings: settings,
                        action: { profile.learningFocusSubjectID = subject.id }
                    )
                }
            }

            PrimaryButton(title: "Continue", iconName: "arrow.right", color: settings.accentColor) {
                step = 3
            }
        }
    }

    private var avatarStep: some View {
        onboardingCard(alignment: .leading) {
            Text("Choose your avatar")
                .font(.studyQuest(.title, weight: .bold))
                .foregroundStyle(settings.primaryText)
            AvatarPreview(color: profile.avatarColor.color, accessory: profile.avatarAccessory)
                .frame(width: 170, height: 170)
                .frame(maxWidth: .infinity)

            Text("Avatar Color")
                .font(.studyQuest(.headline, weight: .bold))
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 72), spacing: 12)], spacing: 12) {
                ForEach(AvatarColor.allCases) { colorChoice in
                    ColorChoiceButton(
                        colorChoice: colorChoice,
                        isSelected: profile.avatarColor == colorChoice,
                        action: { profile.avatarColor = colorChoice }
                    )
                }
            }

            Text("Accessory")
                .font(.studyQuest(.headline, weight: .bold))
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 104), spacing: 12)], spacing: 12) {
                ForEach(AvatarAccessory.allCases) { accessory in
                    AccessoryChoiceButton(
                        accessory: accessory,
                        isSelected: profile.avatarAccessory == accessory,
                        action: { profile.avatarAccessory = accessory }
                    )
                }
            }

            PrimaryButton(title: "Continue", iconName: "arrow.right", color: settings.accentColor) {
                step = 4
            }
        }
    }

    private var meetSparkStep: some View {
        onboardingCard {
            SparkBadge(size: 88)
            Text("Awesome! Everything is ready.")
                .font(.studyQuest(.title, weight: .bold))
                .foregroundStyle(settings.primaryText)
                .multilineTextAlignment(.center)
            VStack(alignment: .leading, spacing: 12) {
                Label("Complete lessons", systemImage: "books.vertical.fill")
                Label("Earn rewards", systemImage: "gift.fill")
                Label("Level up", systemImage: "star.fill")
            }
            .font(.studyQuest(.headline, weight: .bold))
            .foregroundStyle(settings.primaryText)
            Text("I'll always be here if you need help.")
                .font(.studyQuest(.headline, weight: .semibold))
                .foregroundStyle(settings.secondaryText)
                .multilineTextAlignment(.center)
            PrimaryButton(title: "Start Learning", iconName: "play.fill", color: settings.accentColor) {
                profile.hasCompletedOnboarding = true
                complete(profile)
            }
        }
    }

    private func onboardingCard<Content: View>(alignment: HorizontalAlignment = .center, @ViewBuilder content: () -> Content) -> some View {
        ScrollView {
            VStack(alignment: alignment, spacing: 18) {
                content()
            }
            .frame(maxWidth: .infinity, alignment: Alignment(horizontal: alignment, vertical: .center))
            .padding(22)
            .studyQuestCard(settings: settings)
        }
    }
}
