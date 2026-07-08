import SwiftUI

struct ChatsView: View {
    let profile: UserProfile
    let settings: AppAccessibilitySettings
    @Binding var communityData: CommunityData

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 14) {
                    SparkTipCard(
                        message: "Pick a study room, ask a question, or help another learner with a hint.",
                        settings: settings
                    )

                    ForEach(CommunityManager.rooms) { room in
                        NavigationLink {
                            CommunityRoomView(
                                room: room,
                                profile: profile,
                                settings: settings,
                                communityData: $communityData
                            )
                        } label: {
                            CommunityRoomCard(
                                room: room,
                                postCount: CommunityManager.postCount(in: room, data: communityData),
                                settings: settings
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(18)
            }
            .background(settings.screenBackground)
            .navigationTitle("Community")
        }
    }
}

private struct CommunityRoomView: View {
    let room: CommunityRoom
    let profile: UserProfile
    let settings: AppAccessibilitySettings
    @Binding var communityData: CommunityData

    @State private var draftMessage = ""

    private var posts: [CommunityPost] {
        CommunityManager.posts(in: room, data: communityData)
    }

    private var roomColor: Color {
        AppTheme.subjectColor(for: room.subjectID, colorblindMode: settings.colorblindMode)
    }

    private var canPost: Bool {
        !draftMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                LazyVStack(spacing: 14) {
                    roomHeader

                    if posts.isEmpty {
                        SparkTipCard(message: "Why not start the conversation?", settings: settings)
                    } else {
                        ForEach(posts) { post in
                            CommunityPostCard(post: post, settings: settings) {
                                CommunityManager.toggleLike(
                                    postID: post.id,
                                    roomID: room.id,
                                    data: &communityData
                                )
                            }
                        }
                    }
                }
                .padding(18)
            }
            .background(settings.screenBackground)

            composer
        }
        .navigationTitle(room.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var roomHeader: some View {
        HStack(spacing: 14) {
            Image(systemName: room.iconName)
                .font(.system(size: 30, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 62, height: 62)
                .background(roomColor.gradient)
                .clipShape(RoundedRectangle(cornerRadius: 20))

            VStack(alignment: .leading, spacing: 5) {
                Text(room.name)
                    .font(.studyQuest(.title2, weight: .bold))
                    .foregroundStyle(settings.primaryText)
                Text(room.description)
                    .font(.studyQuest(.subheadline, weight: .semibold))
                    .foregroundStyle(settings.secondaryText)
            }

            Spacer(minLength: 0)
        }
        .padding(16)
        .studyQuestCard(settings: settings)
    }

    private var composer: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .bottom, spacing: 10) {
                TextField("Share a question or win...", text: $draftMessage, axis: .vertical)
                    .lineLimit(1...4)
                    .font(.studyQuest(.body, weight: .semibold))
                    .padding(12)
                    .background(settings.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.fieldRadius))
                    .onChange(of: draftMessage) { _, newValue in
                        if newValue.count > 200 {
                            draftMessage = String(newValue.prefix(200))
                        }
                    }
                    .accessibilityLabel("New community post")

                Button(action: createPost) {
                    Image(systemName: "paperplane.fill")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.white)
                        .frame(width: 46, height: 46)
                        .background(canPost ? roomColor.gradient : Color.secondary.opacity(0.4).gradient)
                        .clipShape(Circle())
                }
                .disabled(!canPost)
                .accessibilityLabel("Post message")
            }

            Text("\(draftMessage.count)/200")
                .font(.studyQuest(.caption, weight: .semibold))
                .foregroundStyle(settings.secondaryText)
        }
        .padding(14)
        .background(.regularMaterial)
    }

    private func createPost() {
        CommunityManager.createPost(
            message: draftMessage,
            room: room,
            profile: profile,
            data: &communityData
        )
        draftMessage = ""
    }
}
