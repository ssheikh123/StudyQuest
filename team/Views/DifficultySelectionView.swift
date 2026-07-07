import SwiftUI

struct DifficultySelectionView: View {
    let subject: Subject
    let progress: LessonProgress
    let settings: AppAccessibilitySettings
    let startLesson: (Lesson) -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                subjectHeader

                ForEach(LessonDifficulty.allCases) { difficulty in
                    let lessons = subject.lessons(for: difficulty)
                    let isAvailable = difficulty == .beginner && !lessons.isEmpty
                    let isUnlocked = isAvailable && progress.isDifficultyUnlocked(difficulty, in: subject)

                    if isUnlocked {
                        NavigationLink {
                            LessonListView(
                                subject: subject,
                                difficulty: difficulty,
                                progress: progress,
                                settings: settings,
                                startLesson: startLesson
                            )
                        } label: {
                            DifficultyCard(
                                difficulty: difficulty,
                                lessonCount: lessons.count,
                                completedCount: progress.completedCount(in: subject, difficulty: difficulty),
                                isUnlocked: true,
                                settings: settings
                            )
                        }
                        .buttonStyle(.plain)
                    } else {
                        DifficultyCard(
                            difficulty: difficulty,
                            lessonCount: lessons.count,
                            completedCount: progress.completedCount(in: subject, difficulty: difficulty),
                            isUnlocked: false,
                            settings: settings
                        )
                    }
                }
            }
            .padding(18)
        }
        .background(settings.screenBackground)
        .navigationTitle(subject.title)
    }

    private var subjectHeader: some View {
        HStack(spacing: 14) {
            Image(systemName: subject.iconName)
                .font(.system(size: 34, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 68, height: 68)
                .background((settings.colorblindMode ? Lesson.colorblindColor(for: subject.id) : subject.color).gradient)
                .clipShape(RoundedRectangle(cornerRadius: 20))

            VStack(alignment: .leading, spacing: 5) {
                Text(subject.title)
                    .font(.title.weight(.bold))
                Text("Choose a difficulty")
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(18)
        .background(settings.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.dashboardCornerRadius))
    }
}
