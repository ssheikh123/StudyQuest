import Foundation

enum CommunityManager {
    static let rooms: [CommunityRoom] = [
        CommunityRoom(
            id: "algebra",
            name: "Algebra",
            iconName: "function",
            subjectID: "algebra",
            description: "Ask questions and help others solve problems."
        ),
        CommunityRoom(
            id: "reading",
            name: "Reading",
            iconName: "book.fill",
            subjectID: "reading",
            description: "Share reading strategies and talk through tricky passages."
        ),
        CommunityRoom(
            id: "biology",
            name: "Biology",
            iconName: "leaf.fill",
            subjectID: "biology",
            description: "Explore cells, ecosystems, genetics, and more."
        ),
        CommunityRoom(
            id: "programming-fundamentals",
            name: "Programming",
            iconName: "chevron.left.forwardslash.chevron.right",
            subjectID: "programming-fundamentals",
            description: "Practice coding ideas and explain bugs together."
        )
    ]

    static func posts(in room: CommunityRoom, data: CommunityData) -> [CommunityPost] {
        (data.postsByRoomID[room.id] ?? [])
            .sorted { $0.createdAt > $1.createdAt }
    }

    static func postCount(in room: CommunityRoom, data: CommunityData) -> Int {
        data.postsByRoomID[room.id, default: []].count
    }

    static func createPost(
        message: String,
        room: CommunityRoom,
        profile: UserProfile,
        data: inout CommunityData
    ) {
        let trimmedMessage = String(message.trimmingCharacters(in: .whitespacesAndNewlines).prefix(200))
        guard !trimmedMessage.isEmpty else { return }

        let post = CommunityPost(
            id: UUID().uuidString,
            roomID: room.id,
            userName: profile.userName,
            avatarColorID: profile.avatarColor.id,
            avatarAccessoryID: profile.avatarAccessory.id,
            createdAt: Date(),
            message: trimmedMessage,
            likedByUser: false,
            likeCount: 0
        )

        data.postsByRoomID[room.id, default: []].append(post)
    }

    static func toggleLike(postID: String, roomID: String, data: inout CommunityData) {
        var posts = data.postsByRoomID[roomID] ?? []
        guard let index = posts.firstIndex(where: { $0.id == postID }) else { return }

        posts[index].likedByUser.toggle()
        if posts[index].likedByUser {
            posts[index].likeCount += 1
        } else {
            posts[index].likeCount = max(0, posts[index].likeCount - 1)
        }

        data.postsByRoomID[roomID] = posts
    }

    static func seedSamplePostsIfNeeded(data: inout CommunityData) {
        guard !data.hasSeededSamplePosts else { return }

        let now = Date()
        let samplePosts = [
            CommunityPost(
                id: "sample-algebra-graphing",
                roomID: "algebra",
                userName: "Maya",
                avatarColorID: AvatarColor.mint.id,
                avatarAccessoryID: AvatarAccessory.goggles.id,
                createdAt: now.addingTimeInterval(-1_800),
                message: "What helps you remember slope intercept form? I keep mixing up m and b.",
                likedByUser: false,
                likeCount: 3
            ),
            CommunityPost(
                id: "sample-reading-evidence",
                roomID: "reading",
                userName: "Jordan",
                avatarColorID: AvatarColor.gold.id,
                avatarAccessoryID: AvatarAccessory.stars.id,
                createdAt: now.addingTimeInterval(-5_400),
                message: "My teacher says to cite evidence, but how much of the sentence should I quote?",
                likedByUser: false,
                likeCount: 5
            ),
            CommunityPost(
                id: "sample-biology-cells",
                roomID: "biology",
                userName: "Sam",
                avatarColorID: AvatarColor.coral.id,
                avatarAccessoryID: AvatarAccessory.bolt.id,
                createdAt: now.addingTimeInterval(-8_100),
                message: "I made a mitochondria analogy: it is like a battery pack for the cell.",
                likedByUser: false,
                likeCount: 4
            ),
            CommunityPost(
                id: "sample-programming-loops",
                roomID: "programming-fundamentals",
                userName: "Riley",
                avatarColorID: AvatarColor.violet.id,
                avatarAccessoryID: AvatarAccessory.rocket.id,
                createdAt: now.addingTimeInterval(-10_800),
                message: "For loops finally clicked when I traced the counter on paper first.",
                likedByUser: false,
                likeCount: 6
            )
        ]

        for post in samplePosts {
            data.postsByRoomID[post.roomID, default: []].append(post)
        }
        data.hasSeededSamplePosts = true
    }
}
