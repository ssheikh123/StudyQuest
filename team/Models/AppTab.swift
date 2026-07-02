import SwiftUI

enum AppTab: Int, CaseIterable, Identifiable {
    case home
    case lessons
    case rewards
    case chats
    case profile

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .home:
            return "Home"
        case .lessons:
            return "Lessons"
        case .rewards:
            return "Rewards"
        case .chats:
            return "Chats"
        case .profile:
            return "Profile"
        }
    }

    var iconName: String {
        switch self {
        case .home:
            return "house.fill"
        case .lessons:
            return "book.closed.fill"
        case .rewards:
            return "gift.fill"
        case .chats:
            return "message.fill"
        case .profile:
            return "person.crop.circle.fill"
        }
    }
}
