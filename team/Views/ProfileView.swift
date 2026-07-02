import SwiftUI

struct ProfileView: View {
    let xp: Int
    let level: Int
    let completedLessonIDs: Set<String>
    let settings: AppAccessibilitySettings
    @Binding var avatarColor: AvatarColor
    @Binding var avatarAccessory: AvatarAccessory
    @Binding var accessibilitySettings: AppAccessibilitySettings

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    profilePlaceholder
                    currentTools
                }
                .padding(18)
            }
            .background(settings.screenBackground)
            .navigationTitle("Profile")
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
                    selectedAccessory: $avatarAccessory
                )
            } label: {
                ProfileToolRow(title: "Avatar Studio", subtitle: "Customize your explorer", iconName: "person.crop.circle.fill", settings: settings)
            }

            NavigationLink {
                ProgressDashboardView(
                    xp: xp,
                    level: level,
                    completedCount: completedLessonIDs.count,
                    totalLessons: STEMLesson.lessons.count,
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
