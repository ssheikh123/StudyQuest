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
                            .foregroundStyle(settings.accentColor)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 9)
                            .background(settings.accentColor.opacity(0.12))
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
