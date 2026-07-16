import SwiftUI

enum AvatarSkinTone: String, CaseIterable, Identifiable, Codable {
    case fair = "Fair"
    case light = "Light"
    case medium = "Medium"
    case tan = "Tan"
    case brown = "Brown"
    case deep = "Deep"

    var id: String { rawValue }

    var color: Color {
        switch self {
        case .fair:
            return Color(red: 0.96, green: 0.79, blue: 0.67)
        case .light:
            return Color(red: 0.86, green: 0.61, blue: 0.46)
        case .medium:
            return Color(red: 0.72, green: 0.47, blue: 0.32)
        case .tan:
            return Color(red: 0.56, green: 0.34, blue: 0.22)
        case .brown:
            return Color(red: 0.39, green: 0.23, blue: 0.15)
        case .deep:
            return Color(red: 0.23, green: 0.13, blue: 0.09)
        }
    }
}
