import SwiftUI

struct AnswerButton: View {
    let title: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Spacer()
                Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                    .foregroundStyle(isSelected ? color : .secondary)
            }
            .padding(14)
            .background(isSelected ? color.opacity(0.16) : Color(.tertiarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                    .stroke(isSelected ? color : .clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
        .studyQuestButtonFeedback()
    }
}
