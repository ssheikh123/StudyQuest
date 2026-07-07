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
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
                .background(color.gradient)
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.buttonRadius))
        }
        .buttonStyle(.plain)
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
                .foregroundStyle(color)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(color.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.buttonRadius))
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
    }
}
