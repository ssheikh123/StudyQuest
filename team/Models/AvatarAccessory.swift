import SwiftUI

enum AvatarAccessory: String, CaseIterable, Identifiable {
    case stars = "Stars"
    case goggles = "Goggles"
    case bolt = "Bolt"
    case rocket = "Rocket"

    var id: String { rawValue }

    var iconName: String {
        switch self {
        case .stars:
            return "sparkles"
        case .goggles:
            return "eyeglasses"
        case .bolt:
            return "bolt.fill"
        case .rocket:
            return "paperplane.fill"
        }
    }

    var color: Color {
        switch self {
        case .stars:
            return .yellow
        case .goggles:
            return .black
        case .bolt:
            return .orange
        case .rocket:
            return .red
        }
    }
}
