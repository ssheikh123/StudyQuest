import SwiftUI

struct DifficultySelectionView: View {
    let subject: Subject
    let progress: LessonProgress
    let settings: AppAccessibilitySettings
    @Binding var downloadData: DownloadData
    let startLesson: (Lesson) -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                subjectHeader

                ForEach(LessonDifficulty.allCases) { difficulty in
                    let lessons = subject.lessons(for: difficulty)
                    let hasRealLessons = !lessons.isEmpty
                    let isUnlocked = hasRealLessons && progress.isDifficultyUnlocked(difficulty, in: subject)
                    let displayCount = hasRealLessons ? lessons.count : placeholderLessonCount(for: difficulty)

                    if isUnlocked {
                        NavigationLink {
                            LessonListView(
                                subject: subject,
                                difficulty: difficulty,
                                progress: progress,
                                settings: settings,
                                downloadData: $downloadData,
                                startLesson: startLesson
                            )
                        } label: {
                            DifficultyCard(
                                difficulty: difficulty,
                                lessonCount: displayCount,
                                completedCount: progress.completedCount(in: subject, difficulty: difficulty),
                                isUnlocked: true,
                                settings: settings,
                                statusText: "\(displayCount) lessons",
                                statusBadge: "Unlocked"
                            )
                        }
                        .buttonStyle(.plain)
                    } else {
                        DifficultyCard(
                            difficulty: difficulty,
                            lessonCount: displayCount,
                            completedCount: progress.completedCount(in: subject, difficulty: difficulty),
                            isUnlocked: placeholderIsUnlocked(for: difficulty),
                            settings: settings,
                            statusText: statusText(for: difficulty, hasRealLessons: hasRealLessons),
                            statusBadge: statusBadge(for: difficulty, hasRealLessons: hasRealLessons),
                            showsProgress: hasRealLessons,
                            showsNavigationIndicator: hasRealLessons
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

    private func statusText(for difficulty: LessonDifficulty, hasRealLessons: Bool) -> String {
        if hasRealLessons {
            return "\(progress.completedCount(in: subject, difficulty: difficulty)) of \(subject.lessons(for: difficulty).count) lessons complete"
        }

        switch difficulty {
        case .beginner:
            return "Lessons are being prepared for this level."
        case .intermediate:
            return beginnerComplete
                ? "Intermediate unlocked. 5 lesson placeholders are ready for future content."
                : "Locked until all 5 Beginner lessons are complete."
        case .advanced:
            return intermediateComplete
                ? "Advanced unlocked. 5 lesson placeholders are ready for future content."
                : "Locked until all 5 Intermediate lessons are complete."
        }
    }

    private func statusBadge(for difficulty: LessonDifficulty, hasRealLessons: Bool) -> String {
        if hasRealLessons {
            return progress.isDifficultyUnlocked(difficulty, in: subject) ? "Unlocked" : "Locked"
        }

        switch difficulty {
        case .beginner:
            return "Placeholder"
        case .intermediate:
            return beginnerComplete ? "Unlocked" : "Locked"
        case .advanced:
            return intermediateComplete ? "Unlocked" : "Locked"
        }
    }

    private func placeholderIsUnlocked(for difficulty: LessonDifficulty) -> Bool {
        switch difficulty {
        case .beginner:
            return true
        case .intermediate:
            return beginnerComplete
        case .advanced:
            return intermediateComplete
        }
    }

    private func placeholderLessonCount(for difficulty: LessonDifficulty) -> Int {
        switch difficulty {
        case .beginner:
            return 0
        case .intermediate, .advanced:
            return 5
        }
    }

    private var beginnerComplete: Bool {
        progress.completionPercentage(in: subject, difficulty: .beginner) >= 1
    }

    private var intermediateComplete: Bool {
        let lessons = subject.lessons(for: .intermediate)
        guard !lessons.isEmpty else { return false }
        return progress.completionPercentage(in: subject, difficulty: .intermediate) >= 1
    }
}
