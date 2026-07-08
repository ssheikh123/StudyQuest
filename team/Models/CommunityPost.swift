import Foundation

struct CommunityPost: Identifiable, Codable, Equatable {
    let id: String
    let roomID: String
    let userName: String
    let avatarColorID: String
    let avatarAccessoryID: String
    let createdAt: Date
    var message: String
    var likedByUser: Bool
    var likeCount: Int

    var relativeTimeText: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: createdAt, relativeTo: Date())
    }
}
