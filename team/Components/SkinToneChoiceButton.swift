import SwiftUI

struct SkinToneChoiceButton: View {
    let skinTone: AvatarSkinTone
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Circle()
                    .fill(skinTone.color)
                    .frame(width: 42, height: 42)
                    .overlay(
                        Circle()
                            .stroke(isSelected ? Color.primary : Color.clear, lineWidth: 3)
                    )
                Text(skinTone.rawValue)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.primary)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
        .studyQuestButtonFeedback()
        .accessibilityLabel("\(skinTone.rawValue) skin tone")
    }
}
