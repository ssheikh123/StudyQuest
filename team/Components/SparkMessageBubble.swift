import SwiftUI

struct SparkMessageBubble: View {
    let message: SparkMessage
    let settings: AppAccessibilitySettings

    private var isStudent: Bool {
        message.role == .student
    }

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if isStudent { Spacer(minLength: 36) }
            if !isStudent {
                SparkView(state: .idle, size: 42, reduceMotion: true)
            }

            Text(message.text)
                .font(.studyQuest(.body, weight: .semibold))
                .foregroundStyle(isStudent ? .white : settings.primaryText)
                .padding(12)
                .background(isStudent ? settings.accentColor : settings.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.fieldRadius))
                .accessibilityLabel(isStudent ? "You said: \(message.text)" : "Spark said: \(message.text)")

            if !isStudent { Spacer(minLength: 36) }
        }
    }
}
