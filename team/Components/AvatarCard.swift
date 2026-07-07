import SwiftUI

struct AvatarCard: View {
    let title: String
    let subtitle: String
    let avatarColor: AvatarColor
    let avatarAccessory: AvatarAccessory
    let settings: AppAccessibilitySettings

    var body: some View {
        HStack(spacing: 16) {
            AvatarPreview(color: avatarColor.color, accessory: avatarAccessory)
                .frame(width: 92, height: 92)
                .background(settings.accentColor.opacity(0.08))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.studyQuest(.title3, weight: .bold))
                    .foregroundStyle(settings.primaryText)
                Text(subtitle)
                    .font(.studyQuest(.subheadline, weight: .semibold))
                    .foregroundStyle(settings.secondaryText)
            }

            Spacer()
        }
        .padding(18)
        .studyQuestCard(settings: settings)
    }
}
