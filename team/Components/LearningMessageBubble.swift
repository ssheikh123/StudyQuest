import SwiftUI

struct LearningMessageBubble: View {
    let message: LearningMessage
    let settings: AppAccessibilitySettings

    private var isStudent: Bool {
        message.role == .student
    }

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if isStudent { Spacer(minLength: 36) }

            if !isStudent {
                Image(systemName: "graduationcap.fill")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.white)
                    .frame(width: 38, height: 38)
                    .background(settings.accentColor.gradient)
                    .clipShape(Circle())
                    .accessibilityHidden(true)
            }

            Text(message.text)
                .font(.studyQuest(.body, weight: .semibold))
                .foregroundStyle(isStudent ? .white : settings.primaryText)
                .padding(12)
                .background(isStudent ? settings.accentColor : settings.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.fieldRadius))
                .accessibilityLabel(isStudent ? "You said: \(message.text)" : "Assistant said: \(message.text)")

            if !isStudent { Spacer(minLength: 36) }
        }
    }
}
