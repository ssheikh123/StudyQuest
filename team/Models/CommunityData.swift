import Foundation

struct CommunityData: Codable, Equatable {
    var postsByRoomID: [String: [CommunityPost]] = [:]
    var hasSeededSamplePosts = false
}
