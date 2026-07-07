import SwiftUI

struct QuoteCard: View {
    let quote: String
    let settings: AppAccessibilitySettings

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: "quote.opening")
                .font(.title2.weight(.bold))
                .foregroundStyle(AppTheme.purpleAccent)
                .frame(width: 48, height: 48)
                .background(AppTheme.purpleAccent.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.fieldRadius))

            Text(quote)
                .font(.studyQuest(.headline, weight: .semibold))
                .foregroundStyle(settings.primaryText)
                .fixedSize(horizontal: false, vertical: true)

            Spacer(minLength: 0)
        }
        .padding(18)
        .studyQuestCard(settings: settings)
    }
}
