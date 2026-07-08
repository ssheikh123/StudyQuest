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

    static func seedSamplePostsIfNeeded(data: inout CommunityData) {
        guard !data.hasSeededSamplePosts else { return }

        let samples: [String: [String]] = [
            "algebra": [
                "Can someone explain variables with a real example?",
                "I finally understand solving equations after the worked example."
            ],
            "reading": [
                "Context clues helped me figure out a word without looking it up.",
                "What is your best tip for finding the main idea?"
            ],
            "biology": [
                "This biology lesson was really interesting! Cells are like tiny cities.",
                "Genetics makes more sense when I think about traits as instructions."
            ],
            "programming-fundamentals": [
                "Programming loops make a lot more sense now.",
                "I finally reached Level 5 while practicing arrays!"
            ]
        ]

        let now = Date()
        for room in rooms {
            let messages = samples[room.id] ?? []
            data.postsByRoomID[room.id] = messages.enumerated().map { index, message in
                CommunityPost(
                    id: "sample-\(room.id)-\(index)",
                    roomID: room.id,
                    userName: ["Maya", "Jordan", "Sam", "Riley"][index % 4],
                    avatarColorID: AvatarColor.allCases[index % AvatarColor.allCases.count].id,
                    avatarAccessoryID: AvatarAccessory.allCases[index % AvatarAccessory.allCases.count].id,
                    createdAt: now.addingTimeInterval(TimeInterval(-(index + 1) * 2_700)),
                    message: message,
                    likedByUser: false,
                    likeCount: index + 2
                )
            }
        }

        data.hasSeededSamplePosts = true
    }

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
}
