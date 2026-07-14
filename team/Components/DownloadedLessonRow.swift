import SwiftUI

struct DownloadedLessonRow: View {
    let lesson: Lesson
    let settings: AppAccessibilitySettings
    let removeDownload: () -> Void
    let startLesson: () -> Void

    private var lessonColor: Color {
        lesson.displayColor(colorblindMode: settings.colorblindMode)
    }

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: lesson.iconName)
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 52, height: 52)
                .background(lessonColor.gradient)
                .clipShape(RoundedRectangle(cornerRadius: 16))

            VStack(alignment: .leading, spacing: 5) {
                Text(lesson.title)
                    .font(.studyQuest(.headline, weight: .bold))
                    .foregroundStyle(settings.primaryText)

                Text("\(lesson.subjectTitle) • \(lesson.difficulty.rawValue)")
                    .font(.studyQuest(.subheadline, weight: .semibold))
                    .foregroundStyle(settings.secondaryText)

                Label("Downloaded", systemImage: "arrow.down.circle.fill")
                    .font(.studyQuest(.caption, weight: .bold))
                    .foregroundStyle(AppTheme.greenSuccess)
            }

            Spacer(minLength: 0)

            Menu {
                Button("Start Lesson", systemImage: "play.fill") {
                    FeedbackManager.buttonTap()
                    startLesson()
                }
                Button("Remove Download", systemImage: "trash", role: .destructive) {
                    FeedbackManager.buttonTap()
                    removeDownload()
                }
            } label: {
                Image(systemName: "ellipsis.circle.fill")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(lessonColor)
                    .frame(width: 44, height: 44)
            }
            .studyQuestButtonFeedback()
            .accessibilityLabel("Download options for \(lesson.title)")
        }
        .padding(16)
        .studyQuestCard(settings: settings)
    }
}
