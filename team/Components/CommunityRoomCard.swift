import SwiftUI

struct CommunityRoomCard: View {
    let room: CommunityRoom
    let postCount: Int
    let settings: AppAccessibilitySettings

    private var roomColor: Color {
        AppTheme.subjectColor(for: room.subjectID, colorblindMode: settings.colorblindMode)
    }

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: room.iconName)
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 58, height: 58)
                .background(roomColor.gradient)
                .clipShape(RoundedRectangle(cornerRadius: 18))

            VStack(alignment: .leading, spacing: 6) {
                Text(room.name)
                    .font(.studyQuest(.title3, weight: .bold))
                    .foregroundStyle(settings.primaryText)

                Text(room.description)
                    .font(.studyQuest(.subheadline, weight: .semibold))
                    .foregroundStyle(settings.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)

                Label("\(postCount) posts", systemImage: "text.bubble.fill")
                    .font(.studyQuest(.caption, weight: .bold))
                    .foregroundStyle(roomColor)
            }

            Spacer(minLength: 0)

            Image(systemName: "chevron.right")
                .font(.headline.weight(.bold))
                .foregroundStyle(settings.secondaryText)
        }
        .padding(16)
        .studyQuestCard(settings: settings)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(room.name) community room, \(postCount) posts")
    }
}
