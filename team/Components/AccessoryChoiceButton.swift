import SwiftUI

struct AccessoryChoiceButton: View {
    let accessory: AvatarAccessory
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: accessory.iconName)
                    .font(.title2.weight(.bold))
                    .foregroundStyle(isSelected ? Color.white : accessory.color)
                    .frame(width: 50, height: 50)
                    .background(isSelected ? accessory.color : accessory.color.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius))
                Text(accessory.rawValue)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.primary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
        }
        .buttonStyle(.plain)
    }
}
