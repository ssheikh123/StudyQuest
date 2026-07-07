import Foundation

enum ShopCategory: String, CaseIterable, Identifiable {
    case hats = "Hats"
    case glasses = "Glasses"
    case wings = "Wings"
    case backgrounds = "Backgrounds"
    case colors = "Colors"

    var id: String { rawValue }

    var iconName: String {
        switch self {
        case .hats:
            return "graduationcap.fill"
        case .glasses:
            return "eyeglasses"
        case .wings:
            return "bird.fill"
        case .backgrounds:
            return "photo.fill"
        case .colors:
            return "paintpalette.fill"
        }
    }
}
