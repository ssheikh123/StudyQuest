import SwiftUI

struct ShopItemCard: View {
    let item: ShopItem
    let isOwned: Bool
    let canAfford: Bool
    let settings: AppAccessibilitySettings
    let purchase: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: item.iconName)
                .font(.title.weight(.bold))
                .foregroundStyle(item.color)
                .frame(width: 54, height: 54)
                .background(item.color.opacity(0.14))
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.fieldRadius))

            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.studyQuest(.headline, weight: .bold))
                    .foregroundStyle(settings.primaryText)
                    .lineLimit(2)
                Text(item.category.rawValue)
                    .font(.studyQuest(.caption, weight: .semibold))
                    .foregroundStyle(settings.secondaryText)
            }

            Spacer(minLength: 0)

            Button(action: purchase) {
                Label(isOwned ? "Owned" : "\(item.cost)", systemImage: isOwned ? "checkmark.seal.fill" : "circle.hexagongrid.fill")
                    .font(.studyQuest(.subheadline, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
            }
            .buttonStyle(.borderedProminent)
            .tint(isOwned ? AppTheme.greenSuccess : item.color)
            .disabled(isOwned || !canAfford)
            .opacity((isOwned || canAfford) ? 1 : 0.55)
        }
        .frame(width: 156, height: 210, alignment: .leading)
        .padding(16)
        .studyQuestCard(settings: settings)
    }
}
