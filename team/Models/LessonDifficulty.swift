import SwiftUI

enum LessonDifficulty: String, CaseIterable, Identifiable, Codable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"

    var id: String { rawValue }

    var color: Color {
        switch self {
        case .beginner:
            return .green
        case .intermediate:
            return .blue
        case .advanced:
            return .purple
        }
    }

    var iconName: String {
        switch self {
        case .beginner:
            return "leaf.fill"
        case .intermediate:
            return "arrow.up.circle.fill"
        case .advanced:
            return "sparkles"
        }
    }
}
