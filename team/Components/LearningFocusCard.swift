import SwiftUI

struct LearningFocusCard: View {
    let subject: Subject
    let isSelected: Bool
    let settings: AppAccessibilitySettings
    let action: () -> Void

    private var subjectColor: Color {
        settings.colorblindMode ? Lesson.colorblindColor(for: subject.id) : subject.color
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: subject.iconName)
                    .font(.title.weight(.bold))
                    .foregroundStyle(.white)
                    .frame(width: 58, height: 58)
                    .background(subjectColor.gradient)
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.fieldRadius))

                VStack(alignment: .leading, spacing: 4) {
                    Text(subject.title)
                        .font(.studyQuest(.headline, weight: .bold))
                        .foregroundStyle(settings.primaryText)
                    Text("+10% XP and +5 coins")
                        .font(.studyQuest(.subheadline, weight: .semibold))
                        .foregroundStyle(settings.secondaryText)
                }

                Spacer()

                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(isSelected ? subjectColor : .secondary)
            }
            .padding(16)
            .studyQuestCard(settings: settings, radius: AppTheme.fieldRadius)
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.fieldRadius)
                    .stroke(isSelected ? subjectColor : .clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }
}
