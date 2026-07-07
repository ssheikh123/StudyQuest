import SwiftUI

struct LessonListView: View {
    let subject: Subject
    let difficulty: LessonDifficulty
    let progress: LessonProgress
    let settings: AppAccessibilitySettings
    let startLesson: (Lesson) -> Void

    private var lessons: [Lesson] {
        subject.lessons(for: difficulty)
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                ForEach(lessons) { lesson in
                    let isUnlocked = progress.isLessonUnlocked(lesson, in: subject)
                    LessonPathRow(
                        lesson: lesson,
                        isCompleted: progress.isCompleted(lesson),
                        isUnlocked: isUnlocked,
                        settings: settings,
                        startLesson: { startLesson(lesson) }
                    )
                }
            }
            .padding(18)
        }
        .background(settings.screenBackground)
        .navigationTitle("\(difficulty.rawValue) Lessons")
    }
}

private struct LessonPathRow: View {
    let lesson: Lesson
    let isCompleted: Bool
    let isUnlocked: Bool
    let settings: AppAccessibilitySettings
    let startLesson: () -> Void

    var body: some View {
        HStack(spacing: 14) {
            Text("\(lesson.order)")
                .font(.headline.weight(.bold))
                .foregroundStyle(isUnlocked ? .white : .secondary)
                .frame(width: 44, height: 44)
                .background((isUnlocked ? lesson.displayColor(colorblindMode: settings.colorblindMode) : Color.secondary).opacity(isUnlocked ? 1 : 0.16))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 8) {
                    Text(lesson.title)
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.primary)
                    if isCompleted {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundStyle(.green)
                    }
                }

                Text("\(lesson.estimatedTime) • \(lesson.xpReward) XP • \(lesson.badgeProgress)% badge")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Button(action: startLesson) {
                Image(systemName: isUnlocked ? (isCompleted ? "arrow.clockwise" : "play.fill") : "lock.fill")
                    .font(.headline.weight(.bold))
                    .frame(width: 44, height: 44)
            }
            .buttonStyle(.borderedProminent)
            .tint(isUnlocked ? lesson.displayColor(colorblindMode: settings.colorblindMode) : .gray)
            .disabled(!isUnlocked)
            .accessibilityLabel(isUnlocked ? "Start \(lesson.title)" : "\(lesson.title) locked")
        }
        .padding(16)
        .background(settings.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.dashboardCornerRadius))
    }
}
