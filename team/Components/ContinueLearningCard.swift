import SwiftUI

struct ContinueLearningCard: View {
    let lesson: Lesson
    let progress: Double
    let settings: AppAccessibilitySettings
    let action: () -> Void

    private var lessonColor: Color {
        lesson.displayColor(colorblindMode: settings.colorblindMode)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .top, spacing: 14) {
                Image(systemName: lesson.iconName)
                    .font(.system(size: 36, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 68, height: 68)
                    .background(lessonColor.gradient)
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.buttonRadius))

                VStack(alignment: .leading, spacing: 5) {
                    Text("Continue Learning")
                        .font(.studyQuest(.caption, weight: .bold))
                        .foregroundStyle(lessonColor)
                        .textCase(.uppercase)
                    Text(lesson.subjectTitle)
                        .font(.studyQuest(.headline, weight: .semibold))
                        .foregroundStyle(settings.secondaryText)
                    Text(lesson.title)
                        .font(.studyQuest(.title2, weight: .bold))
                        .foregroundStyle(settings.primaryText)
                }

                Spacer()
            }

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Adventure path")
                    Spacer()
                    Text("\(Int(progress * 100))%")
                }
                .font(.studyQuest(.subheadline, weight: .semibold))
                .foregroundStyle(settings.secondaryText)

                ProgressBar(value: progress, tint: lessonColor, minimumFillWidth: 12)
                    .frame(height: 12)
            }

            PrimaryButton(title: "Continue", iconName: "play.fill", color: lessonColor, action: action)
        }
        .padding(20)
        .studyQuestCard(settings: settings)
        .accessibilityElement(children: .contain)
    }
}
