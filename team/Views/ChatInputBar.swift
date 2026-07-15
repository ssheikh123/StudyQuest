import SwiftUI

struct ChatInputBar: View {
    @Binding var text: String
    let isSending: Bool
    let settings: AppAccessibilitySettings
    let send: () -> Void

    private var canSend: Bool {
        !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !isSending
    }

    var body: some View {
        HStack(alignment: .bottom, spacing: 10) {
            TextField("Ask the AI tutor", text: $text, axis: .vertical)
                .font(.studyQuest(.body, weight: .regular))
                .lineLimit(1...4)
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(settings.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.fieldRadius))
                .accessibilityLabel("Message to AI tutor")

            Button(action: send) {
                if isSending {
                    ProgressView()
                        .tint(.white)
                        .frame(width: 44, height: 44)
                } else {
                    Image(systemName: "paperplane.fill")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.white)
                        .frame(width: 44, height: 44)
                }
            }
            .background(canSend ? settings.accentColor.gradient : Color.secondary.opacity(0.45).gradient)
            .clipShape(Circle())
            .disabled(!canSend)
            .studyQuestButtonFeedback()
            .accessibilityLabel("Send message")
        }
        .padding(14)
        .background(.regularMaterial)
    }
}
