import SwiftUI

struct DifficultyCard: View {
    let difficulty: LessonDifficulty
    let lessonCount: Int
    let completedCount: Int
    let isUnlocked: Bool
    let settings: AppAccessibilitySettings
    var statusText: String? = nil
    var statusBadge: String? = nil
    var showsProgress = true
    var showsNavigationIndicator = true

    private var progress: Double {
        guard lessonCount > 0 else { return 0 }
        return Double(completedCount) / Double(lessonCount)
    }

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: isUnlocked ? difficulty.iconName : "lock.fill")
                .font(.title.weight(.bold))
                .foregroundStyle(isUnlocked ? difficulty.color : .secondary)
                .frame(width: 60, height: 60)
                .background((isUnlocked ? difficulty.color : Color.secondary).opacity(0.14))
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.fieldRadius))

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(difficulty.rawValue)
                        .font(.studyQuest(.headline, weight: .bold))
                        .foregroundStyle(settings.primaryText)
                    Text(statusBadge ?? (isUnlocked ? "Unlocked" : "Locked"))
                        .font(.studyQuest(.caption, weight: .bold))
                        .foregroundStyle(isUnlocked ? difficulty.color : settings.secondaryText)
                }

                Text(statusText ?? "\(lessonCount) lessons")
                    .font(.studyQuest(.subheadline, weight: .semibold))
                    .foregroundStyle(settings.secondaryText)

                if showsProgress {
                    ProgressBar(value: progress, tint: isUnlocked ? difficulty.color : .secondary)
                        .frame(height: 8)
                }
            }

            Spacer()
            Image(systemName: isUnlocked && showsNavigationIndicator && lessonCount > 0 ? "chevron.right" : "lock.fill")
                .font(.caption.weight(.bold))
                .foregroundStyle(.tertiary)
        }
        .padding(18)
        .studyQuestCard(settings: settings)
    }
}
