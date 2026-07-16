import SwiftUI

struct PrimaryButton: View {
    let title: String
    let iconName: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label(title, systemImage: iconName)
                .font(.studyQuest(.headline, weight: .bold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, minHeight: 56)
                .background(
                    LinearGradient(
                        colors: [color, color.opacity(0.78)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.buttonRadius, style: .continuous))
                .shadow(color: color.opacity(0.24), radius: 16, x: 0, y: 8)
        }
        .buttonStyle(.plain)
        .studyQuestButtonFeedback()
        .accessibilityLabel(title)
    }
}

struct SecondaryButton: View {
    let title: String
    let iconName: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label(title, systemImage: iconName)
                .font(.studyQuest(.headline, weight: .bold))
                .foregroundStyle(Color.primary)
                .frame(maxWidth: .infinity, minHeight: 56)
                .background(Color(.secondarySystemGroupedBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.buttonRadius, style: .continuous)
                        .stroke(color.opacity(0.28), lineWidth: 1.5)
                )
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.buttonRadius, style: .continuous))
        }
        .buttonStyle(.plain)
        .studyQuestButtonFeedback()
        .accessibilityLabel(title)
    }
}
