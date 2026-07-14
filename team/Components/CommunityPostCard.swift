import SwiftUI

struct CommunityPostCard: View {
    let post: CommunityPost
    let settings: AppAccessibilitySettings
    let toggleLike: () -> Void

    private var avatarColor: AvatarColor {
        AvatarColor(rawValue: post.avatarColorID) ?? .sky
    }

    private var avatarAccessory: AvatarAccessory {
        AvatarAccessory(rawValue: post.avatarAccessoryID) ?? .stars
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                AvatarPreview(color: avatarColor.color, accessory: avatarAccessory)
                    .frame(width: 48, height: 48)
                    .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: 4) {
                    Text(post.userName)
                        .font(.studyQuest(.headline, weight: .bold))
                        .foregroundStyle(settings.primaryText)
                    Text(post.relativeTimeText)
                        .font(.studyQuest(.caption, weight: .semibold))
                        .foregroundStyle(settings.secondaryText)
                }

                Spacer(minLength: 0)
            }

            Text(post.message)
                .font(.studyQuest(.body, weight: .semibold))
                .foregroundStyle(settings.primaryText)
                .fixedSize(horizontal: false, vertical: true)

            Button(action: toggleLike) {
                Label("\(post.likeCount)", systemImage: post.likedByUser ? "heart.fill" : "heart")
                    .font(.studyQuest(.subheadline, weight: .bold))
                    .foregroundStyle(post.likedByUser ? AppTheme.coral : settings.secondaryText)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background((post.likedByUser ? AppTheme.coral : Color.secondary).opacity(0.12))
                    .clipShape(Capsule())
            }
            .buttonStyle(.plain)
            .studyQuestButtonFeedback()
            .accessibilityLabel(post.likedByUser ? "Unlike post" : "Like post")
            .accessibilityValue("\(post.likeCount) likes")
        }
        .padding(16)
        .studyQuestCard(settings: settings)
        .accessibilityElement(children: .contain)
    }
}
