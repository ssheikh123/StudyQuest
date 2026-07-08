import Foundation

struct CommunityRoom: Identifiable, Codable, Equatable {
    let id: String
    let name: String
    let iconName: String
    let subjectID: String
    let description: String
}
