import SwiftUI

struct SparkTipCard: View {
    let message: String
    let settings: AppAccessibilitySettings

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            SparkBadge(size: 54)

            VStack(alignment: .leading, spacing: 5) {
                Text("Spark says")
                    .font(.studyQuest(.caption, weight: .bold))
                    .textCase(.uppercase)
                    .foregroundStyle(AppTheme.coral)
                Text(message)
                    .font(.studyQuest(.headline, weight: .semibold))
                    .foregroundStyle(settings.primaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 0)
        }
        .padding(18)
        .studyQuestCard(settings: settings)
    }
}

struct SparkBadge: View {
    var size: CGFloat = 48

    var body: some View {
        ZStack {
            Circle()
                .fill(LinearGradient(colors: [AppTheme.coral, AppTheme.goldReward], startPoint: .topLeading, endPoint: .bottomTrailing))
            Image(systemName: "sparkles")
                .font(.system(size: size * 0.38, weight: .bold))
                .foregroundStyle(.white)
        }
        .frame(width: size, height: size)
        .accessibilityLabel("Spark")
    }
}
