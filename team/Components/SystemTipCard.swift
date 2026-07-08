import SwiftUI

struct SystemTipCard: View {
    let message: String
    let settings: AppAccessibilitySettings

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            SystemTipIcon(size: 54)

            Text(message)
                .font(.studyQuest(.headline, weight: .semibold))
                .foregroundStyle(settings.primaryText)
                .fixedSize(horizontal: false, vertical: true)

            Spacer(minLength: 0)
        }
        .padding(18)
        .studyQuestCard(settings: settings)
    }
}

struct SystemTipIcon: View {
    var size: CGFloat = 48

    var body: some View {
        ZStack {
            Circle()
                .fill(LinearGradient(colors: [AppTheme.coral, AppTheme.goldReward], startPoint: .topLeading, endPoint: .bottomTrailing))
            Image(systemName: "lightbulb.fill")
                .font(.system(size: size * 0.36, weight: .bold))
                .foregroundStyle(.white)
        }
        .frame(width: size, height: size)
        .accessibilityLabel("Tip")
    }
}
