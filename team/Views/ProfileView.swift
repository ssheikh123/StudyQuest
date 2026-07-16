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

    private var completedCount: Int {
        progress.completedLessonIDs.count
    }

    private var totalLessons: Int {
        CurriculumData.beginnerLessons.count
    }

    private var selectedFocusSubject: Subject? {
        CurriculumData.subjects.first { $0.id == learningFocusSubjectID }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    profileHeader
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

    private var profileHeader: some View {
        VStack(spacing: 18) {
            HStack(spacing: 16) {
                AvatarPreview(color: avatarColor.color, accessory: avatarAccessory, contentScale: 0.70, reduceMotion: true)
                    .frame(width: 128, height: 128)
                    .background(AppTheme.primary.opacity(settings.darkMode ? 0.18 : 0.10))
                    .clipShape(Circle())
                    .overlay {
                        Circle()
                            .stroke(settings.darkMode ? Color.white.opacity(0.10) : Color.white.opacity(0.8), lineWidth: 1)
                    }
                    .accessibilityLabel("Current avatar")

                VStack(alignment: .leading, spacing: 8) {
                    Text("Level \(level) Explorer")
                        .font(.studyQuest(.title2, weight: .bold))
                        .foregroundStyle(settings.primaryText)
                    Text("\(Leveling.xpUntilNextLevel(for: xp)) EXP until next level")
                        .font(.studyQuest(.headline, weight: .semibold))
                        .foregroundStyle(settings.secondaryText)
                    Text(selectedFocusSubject?.title ?? "Choose a learning focus")
                        .font(.studyQuest(.caption, weight: .bold))
                        .foregroundStyle(settings.darkMode ? Color(red: 0.17, green: 0.08, blue: 0.42) : Color.black)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 7)
                        .background(settings.darkMode ? Color(red: 0.86, green: 0.80, blue: 1.0) : AppTheme.primary.opacity(0.12))
                        .clipShape(Capsule())
                }

                Spacer(minLength: 0)
            }

            XPBar(xp: xp, settings: settings)
                .padding(14)
                .background(settings.screenBackground)
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.fieldRadius, style: .continuous))

            HStack(spacing: 10) {
                ProfileStatChip(title: "Lessons", value: "\(completedCount)/\(totalLessons)", iconName: "book.closed.fill", color: AppTheme.blueAccent, settings: settings)
                ProfileStatChip(title: "Coins", value: "\(wallet.coins)", iconName: "circle.hexagongrid.fill", color: AppTheme.goldReward, settings: settings)
                ProfileStatChip(title: "Badges", value: "\(unlockedBadgeCount)", iconName: "rosette", color: AppTheme.pinkCommunity, settings: settings)
            }
        }
        .padding(18)
        .studyQuestCard(settings: settings, radius: AppTheme.cardRadius)
    }

    private var unlockedBadgeCount: Int {
        RewardsCatalog.badges(progress: progress, xp: xp, level: level, streak: StreakData()).filter(\.isUnlocked).count
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
            Text("Tools")
                .font(.studyQuest(.title3, weight: .bold))
                .foregroundStyle(settings.primaryText)

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
        .studyQuestCard(settings: settings, radius: AppTheme.cornerRadius)
    }

    private var accountSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Account")
                .font(.studyQuest(.title3, weight: .bold))
                .foregroundStyle(settings.primaryText)

            Button(role: .destructive) {
                showResetConfirmation = true
            } label: {
                Label("Delete Profile", systemImage: "trash.fill")
                    .font(.studyQuest(.headline, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
            }
            .buttonStyle(.borderedProminent)
            .studyQuestButtonFeedback()
            .tint(.red)
        }
        .padding(18)
        .studyQuestCard(settings: settings, radius: AppTheme.cornerRadius)
    }
}

private struct ProfileStatChip: View {
    let title: String
    let value: String
    let iconName: String
    let color: Color
    let settings: AppAccessibilitySettings

    var body: some View {
        VStack(spacing: 7) {
            Image(systemName: iconName)
                .font(.headline.weight(.bold))
                .foregroundStyle(color)
            Text(value)
                .font(.studyQuest(.headline, weight: .bold))
                .foregroundStyle(settings.primaryText)
                .lineLimit(1)
                .minimumScaleFactor(0.75)
            Text(title)
                .font(.studyQuest(.caption2, weight: .bold))
                .foregroundStyle(settings.secondaryText)
                .textCase(.uppercase)
                .lineLimit(1)
                .minimumScaleFactor(0.75)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(settings.screenBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.fieldRadius, style: .continuous))
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
                .foregroundStyle(settings.darkMode ? Color(red: 0.17, green: 0.08, blue: 0.42) : Color.black)
                .frame(width: 42, height: 42)
                .background(settings.darkMode ? Color(red: 0.86, green: 0.80, blue: 1.0) : AppTheme.primary.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.studyQuest(.headline, weight: .bold))
                    .foregroundStyle(settings.primaryText)
                Text(subtitle)
                    .font(.studyQuest(.subheadline, weight: .semibold))
                    .foregroundStyle(settings.secondaryText)
            }

            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption.weight(.bold))
                .foregroundStyle(settings.secondaryText)
        }
        .padding(12)
        .background(settings.screenBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.fieldRadius, style: .continuous))
    }
}
