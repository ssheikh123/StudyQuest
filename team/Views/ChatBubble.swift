import SwiftUI

struct ChatBubble: View {
    let message: ChatMessage
    let settings: AppAccessibilitySettings
    let copy: () -> Void
    let retry: (() -> Void)?

    private var isStudent: Bool {
        message.sender == .student
    }

    var body: some View {
        HStack(alignment: .bottom) {
            if isStudent {
                Spacer(minLength: 46)
            }

            VStack(alignment: isStudent ? .trailing : .leading, spacing: 6) {
                Text(.init(message.content))
                    .font(.studyQuest(.body, weight: .regular))
                    .foregroundStyle(isStudent ? .white : settings.primaryText)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 11)
                    .background(bubbleBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .textSelection(.enabled)
                    .contextMenu {
                        Button("Copy", action: copy)
                        if let retry, message.deliveryState == .failed {
                            Button("Retry", action: retry)
                        }
                    }

                HStack(spacing: 8) {
                    Text(message.timestamp.formatted(date: .omitted, time: .shortened))
                    if message.deliveryState == .failed {
                        Label("Failed", systemImage: "exclamationmark.triangle.fill")
                    }
                }
                .font(.studyQuest(.caption2, weight: .semibold))
                .foregroundStyle(settings.secondaryText)
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel(accessibilityLabel)

            if !isStudent {
                Spacer(minLength: 46)
            }
        }
        .transition(.opacity.combined(with: .move(edge: isStudent ? .trailing : .leading)))
    }

    private var bubbleBackground: some ShapeStyle {
        if isStudent {
            return AnyShapeStyle(settings.accentColor.gradient)
        }

        if message.deliveryState == .failed {
            return AnyShapeStyle(AppTheme.coral.opacity(settings.darkMode ? 0.22 : 0.12))
        }

        return AnyShapeStyle(settings.cardBackground)
    }

    private var accessibilityLabel: String {
        let sender = isStudent ? "You" : "AI tutor"
        return "\(sender), \(message.content)"
    }
}
