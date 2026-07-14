import SwiftUI

struct LessonCard: View {
    let lesson: Lesson
    let isCompleted: Bool
    let settings: AppAccessibilitySettings
    let startLesson: () -> Void

    private var lessonColor: Color {
        lesson.displayColor(colorblindMode: settings.colorblindMode)
    }

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                    .fill(lessonColor.opacity(0.18))
                Image(systemName: lesson.iconName)
                    .font(.title.weight(.bold))
                    .foregroundStyle(lessonColor)
            }
            .frame(width: 64, height: 64)

            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 8) {
                    Text(lesson.difficulty.rawValue)
                        .font(.caption.weight(.bold))
                        .foregroundStyle(lessonColor)
                    if isCompleted {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundStyle(.green)
                    }
                }

                Text(lesson.title)
                    .font(.headline)
                    .foregroundStyle(.primary)

                Text("\(lesson.xpReward) XP")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Button(action: startLesson) {
                if settings.buttonLabels {
                    Label(isCompleted ? "Retake" : "Start", systemImage: isCompleted ? "arrow.clockwise" : "play.fill")
                        .font(.headline.weight(.bold))
                        .frame(minWidth: 74, minHeight: 44)
                } else {
                    Image(systemName: isCompleted ? "arrow.clockwise" : "play.fill")
                        .font(.headline.weight(.bold))
                        .frame(width: 44, height: 44)
                }
            }
            .buttonStyle(.borderedProminent)
            .studyQuestButtonFeedback()
            .tint(lessonColor)
            .accessibilityLabel(isCompleted ? "Retake lesson" : "Start lesson")
        }
        .padding(14)
        .background(settings.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius))
        .shadow(color: AppTheme.cardShadow, radius: 10, x: 0, y: 5)
    }
}
