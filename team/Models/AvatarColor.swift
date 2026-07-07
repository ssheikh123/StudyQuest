import SwiftUI

enum AvatarColor: String, CaseIterable, Identifiable, Codable {
    case sky = "Sky"
    case mint = "Mint"
    case coral = "Coral"
    case violet = "Violet"
    case gold = "Gold"
    case navy = "Navy"

    var id: String { rawValue }

    var color: Color {
        switch self {
        case .sky:
            return Color(red: 0.22, green: 0.58, blue: 0.95)
        case .mint:
            return Color(red: 0.10, green: 0.72, blue: 0.52)
        case .coral:
            return Color(red: 0.96, green: 0.36, blue: 0.30)
        case .violet:
            return Color(red: 0.50, green: 0.32, blue: 0.88)
        case .gold:
            return Color(red: 0.94, green: 0.64, blue: 0.10)
        case .navy:
            return Color(red: 0.13, green: 0.20, blue: 0.38)
        }
    }
}
