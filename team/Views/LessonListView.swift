import SwiftUI

struct LessonListView: View {
    let subject: Subject
    let difficulty: LessonDifficulty
    let progress: LessonProgress
    let settings: AppAccessibilitySettings
    @Binding var downloadData: DownloadData
    let startLesson: (Lesson) -> Void

    @State private var filter = LessonDownloadFilter.all

    private var lessons: [Lesson] {
        let subjectLessons = subject.lessons(for: difficulty)
        switch filter {
        case .all:
            return subjectLessons
        case .downloadedOnly:
            return subjectLessons.filter { DownloadManager.isDownloaded($0, data: downloadData) }
        }
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Picker("Lesson filter", selection: $filter) {
                    ForEach(LessonDownloadFilter.allCases) { filter in
                        Text(filter.title).tag(filter)
                    }
                }
                .pickerStyle(.segmented)
                .accessibilityLabel("Lesson filter")

                if lessons.isEmpty {
                    SystemTipCard(
                        message: "No downloaded lessons match this filter yet. Tap Download Lesson on any lesson to save it here.",
                        settings: settings
                    )
                } else {
                    ForEach(lessons) { lesson in
                        let isUnlocked = progress.isLessonUnlocked(lesson, in: subject)
                        LessonPathRow(
                            lesson: lesson,
                            isCompleted: progress.isCompleted(lesson),
                            isUnlocked: isUnlocked,
                            isDownloaded: DownloadManager.isDownloaded(lesson, data: downloadData),
                            settings: settings,
                            startLesson: { startLesson(lesson) },
                            toggleDownload: {
                                toggleDownload(for: lesson)
                            }
                        )
                    }
                }
            }
            .padding(18)
        }
        .background(settings.screenBackground)
        .navigationTitle("\(difficulty.rawValue) Lessons")
    }

    private func toggleDownload(for lesson: Lesson) {
        if DownloadManager.isDownloaded(lesson, data: downloadData) {
            DownloadManager.removeDownload(lesson, data: &downloadData)
        } else {
            DownloadManager.markDownloaded(lesson, data: &downloadData)
        }
    }
}

private enum LessonDownloadFilter: String, CaseIterable, Identifiable {
    case all
    case downloadedOnly

    var id: String { rawValue }

    var title: String {
        switch self {
        case .all:
            return "All Lessons"
        case .downloadedOnly:
            return "Downloaded Only"
        }
    }
}

private struct LessonPathRow: View {
    let lesson: Lesson
    let isCompleted: Bool
    let isUnlocked: Bool
    let isDownloaded: Bool
    let settings: AppAccessibilitySettings
    let startLesson: () -> Void
    let toggleDownload: () -> Void

    var body: some View {
        VStack(spacing: 14) {
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
                                .accessibilityLabel("Completed")
                        }
                        if isDownloaded {
                            Image(systemName: "arrow.down.circle.fill")
                                .foregroundStyle(AppTheme.greenSuccess)
                                .accessibilityLabel("Downloaded")
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
                .studyQuestButtonFeedback()
                .accessibilityLabel(isUnlocked ? "Start \(lesson.title)" : "\(lesson.title) locked")
            }

            Button(action: toggleDownload) {
                Label(isDownloaded ? "Downloaded" : "Download Lesson", systemImage: isDownloaded ? "checkmark.circle.fill" : "arrow.down.circle")
                    .font(.studyQuest(.subheadline, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background((isDownloaded ? AppTheme.greenSuccess : lesson.displayColor(colorblindMode: settings.colorblindMode)).opacity(0.13))
                    .foregroundStyle(isDownloaded ? AppTheme.greenSuccess : lesson.displayColor(colorblindMode: settings.colorblindMode))
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.buttonRadius))
            }
            .buttonStyle(.plain)
            .studyQuestButtonFeedback()
            .accessibilityLabel(isDownloaded ? "Remove downloaded lesson \(lesson.title)" : "Download lesson \(lesson.title)")
        }
        .padding(16)
        .background(settings.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.dashboardCornerRadius))
    }
}
