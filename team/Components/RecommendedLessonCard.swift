import SwiftUI

struct RecommendedLessonCard: View {
    let lesson: Lesson
    let difficulty: String
    let estimatedTime: String
    let settings: AppAccessibilitySettings
    let action: () -> Void

    private var lessonColor: Color {
        lesson.displayColor(colorblindMode: settings.colorblindMode)
    }

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 14) {
                Image(systemName: lesson.iconName)
                    .font(.title.weight(.bold))
                    .foregroundStyle(.white)
                    .frame(width: 58, height: 58)
                    .background(lessonColor.gradient)
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.fieldRadius))

                VStack(alignment: .leading, spacing: 6) {
                    Text(lesson.subjectTitle)
                        .font(.studyQuest(.caption, weight: .bold))
                        .foregroundStyle(lessonColor)
                    Text(lesson.title)
                        .font(.studyQuest(.headline, weight: .bold))
                        .foregroundStyle(settings.primaryText)
                        .lineLimit(2)
                }

                Spacer(minLength: 0)

                VStack(alignment: .leading, spacing: 7) {
                    Label(difficulty, systemImage: "graduationcap.fill")
                    Label(estimatedTime, systemImage: "clock.fill")
                    Label("\(lesson.xpReward) XP", systemImage: "bolt.fill")
                }
                .font(.studyQuest(.caption, weight: .semibold))
                .foregroundStyle(settings.secondaryText)
            }
            .frame(width: 176, height: 228, alignment: .leading)
            .padding(18)
            .studyQuestCard(settings: settings)
        }
        .buttonStyle(.plain)
        .studyQuestButtonFeedback()
        .accessibilityLabel("Start recommended lesson \(lesson.title)")
    }
}
