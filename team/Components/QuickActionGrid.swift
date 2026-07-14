import SwiftUI

struct QuickActionGrid: View {
    let actions: [QuickAction]
    let settings: AppAccessibilitySettings

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Quick Actions")
                .font(.title3.weight(.bold))

            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(actions) { item in
                    Button(action: item.action) {
                        VStack(alignment: .leading, spacing: 10) {
                            Image(systemName: item.iconName)
                                .font(.title2.weight(.bold))
                                .foregroundStyle(item.color)
                                .frame(width: 44, height: 44)
                                .background(item.color.opacity(0.13))
                                .clipShape(RoundedRectangle(cornerRadius: 16))

                            Text(item.title)
                                .font(.headline.weight(.bold))
                                .foregroundStyle(.primary)
                                .lineLimit(2)
                                .minimumScaleFactor(0.82)
                        }
                        .frame(maxWidth: .infinity, minHeight: 118, alignment: .leading)
                        .padding(14)
                        .background(settings.cardBackground)
                        .clipShape(RoundedRectangle(cornerRadius: AppTheme.dashboardCornerRadius))
                    }
                    .buttonStyle(.plain)
                    .studyQuestButtonFeedback()
                    .accessibilityLabel(item.title)
                }
            }
        }
    }
}

struct QuickAction: Identifiable {
    let id: String
    let title: String
    let iconName: String
    let color: Color
    let action: () -> Void
}
