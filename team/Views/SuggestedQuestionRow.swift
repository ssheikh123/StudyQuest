import SwiftUI

struct SuggestedQuestionRow: View {
    let prompts: [SuggestedPrompt]
    let settings: AppAccessibilitySettings
    let send: (SuggestedPrompt) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(prompts) { prompt in
                    Button {
                        send(prompt)
                    } label: {
                        Text(prompt.title)
                            .font(.studyQuest(.caption, weight: .bold))
                            .foregroundStyle(settings.darkMode ? Color(red: 0.17, green: 0.08, blue: 0.42) : Color.black)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 9)
                            .background(settings.darkMode ? Color(red: 0.86, green: 0.80, blue: 1.0) : AppTheme.primary.opacity(0.12))
                            .overlay {
                                Capsule()
                                    .stroke(settings.darkMode ? Color.white.opacity(0.12) : AppTheme.primary.opacity(0.16), lineWidth: 1)
                            }
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                    .studyQuestButtonFeedback()
                    .accessibilityLabel(prompt.title)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
        }
    }
}
