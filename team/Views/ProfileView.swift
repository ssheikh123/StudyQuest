import SwiftUI

struct ProfileView: View {
    let xp: Int
    let level: Int
    let progress: LessonProgress
    let settings: AppAccessibilitySettings
    @Binding var wallet: RewardsWallet
    @Binding var avatarColor: AvatarColor
    @Binding var avatarAccessory: AvatarAccessory
    @Binding var learningFocusSubjectID: String
    @Binding var accessibilitySettings: AppAccessibilitySettings
    let resetProfile: () -> Void

    @State private var showResetConfirmation = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    profilePlaceholder
                    learningFocusSection
                    currentTools
                    accountSection
                }
                .padding(18)
            }
            .background(settings.screenBackground)
            .navigationTitle("Profile")
            .alert("Delete your StudyQuest profile?", isPresented: $showResetConfirmation) {
                Button("Cancel", role: .cancel) {
                    FeedbackManager.buttonTap()
                }
                Button("Delete Profile", role: .destructive) {
                    FeedbackManager.buttonTap()
                    resetProfile()
                }
            } message: {
                Text("This will erase your name, XP, coins, progress, lessons, rewards, avatar, purchased cosmetics, accessibility settings, theme, and daily streak. This action cannot be undone.")
            }
        }
    }

    private var profilePlaceholder: some View {
        VStack(spacing: 14) {
            Image(systemName: "person.crop.circle.fill")
                .font(.system(size: 54, weight: .bold))
                .foregroundStyle(settings.accentColor)
                .frame(width: 96, height: 96)
                .background(settings.accentColor.opacity(0.14))
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius))

            VStack(spacing: 6) {
                Text("Profile")
                    .font(.largeTitle.weight(.bold))
                Text("Coming Soon")
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(22)
        .background(settings.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius))
    }

    private var learningFocusSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Learning Focus", subtitle: "+10% XP and +5 coins for this subject")

            ForEach(CurriculumData.subjects) { subject in
                LearningFocusCard(
                    subject: subject,
                    isSelected: learningFocusSubjectID == subject.id,
                    settings: settings,
                    action: { learningFocusSubjectID = subject.id }
                )
            }
        }
        .padding(18)
        .studyQuestCard(settings: settings, radius: AppTheme.cornerRadius)
    }

    private var currentTools: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Current Tools")
                .font(.title3.weight(.bold))

            NavigationLink {
                AvatarStudioView(
                    xp: xp,
                    level: level,
                    settings: settings,
                    selectedColor: $avatarColor,
                    selectedAccessory: $avatarAccessory,
                    wallet: $wallet
                )
            } label: {
                ProfileToolRow(title: "Avatar Studio", subtitle: "Customize your explorer", iconName: "person.crop.circle.fill", settings: settings)
            }

            NavigationLink {
                ProgressDashboardView(
                    xp: xp,
                    level: level,
                    progress: progress,
                    avatarColor: avatarColor,
                    avatarAccessory: avatarAccessory,
                    settings: settings
                )
            } label: {
                ProfileToolRow(title: "Progress", subtitle: "Review XP and lesson completion", iconName: "chart.bar.fill", settings: settings)
            }

            NavigationLink {
                SettingsView(settings: $accessibilitySettings)
            } label: {
                ProfileToolRow(title: "Settings", subtitle: "Accessibility and app preferences", iconName: "gearshape.fill", settings: settings)
            }
        }
        .padding(18)
        .background(settings.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius))
    }

    private var accountSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Account")
                .font(.title3.weight(.bold))

            Button(role: .destructive) {
                showResetConfirmation = true
            } label: {
                Label("Delete Profile", systemImage: "trash.fill")
                    .font(.headline.weight(.bold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
            }
            .buttonStyle(.borderedProminent)
            .studyQuestButtonFeedback()
            .tint(.red)
        }
        .padding(18)
        .background(settings.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius))
    }
}

private struct ProfileToolRow: View {
    let title: String
    let subtitle: String
    let iconName: String
    let settings: AppAccessibilitySettings

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: iconName)
                .font(.title3.weight(.bold))
                .foregroundStyle(settings.accentColor)
                .frame(width: 42, height: 42)
                .background(settings.accentColor.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius))

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption.weight(.bold))
                .foregroundStyle(.tertiary)
        }
        .padding(12)
        .background(Color(.tertiarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius))
    }
}
