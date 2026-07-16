import SwiftUI

enum AppTheme {
    static let cornerRadius: CGFloat = 24
    static let cardRadius: CGFloat = 24
    static let buttonRadius: CGFloat = 20
    static let fieldRadius: CGFloat = 18
    static let dashboardCornerRadius: CGFloat = cardRadius

    static let background = Color(red: 0.973, green: 0.976, blue: 0.988)
    static let primary = Color(red: 0.486, green: 0.361, blue: 1.0)
    static let purpleAccent = Color(red: 0.608, green: 0.486, blue: 1.0)
    static let blueAccent = Color(red: 0.337, green: 0.722, blue: 1.0)
    static let greenSuccess = Color(red: 0.329, green: 0.843, blue: 0.647)
    static let goldReward = Color(red: 1.0, green: 0.714, blue: 0.282)
    static let pinkCommunity = Color(red: 1.0, green: 0.498, blue: 0.686)
    static let coral = Color(red: 1.0, green: 0.431, blue: 0.431)
    static let primaryText = Color(red: 0.086, green: 0.098, blue: 0.145)
    static let secondaryText = Color(red: 0.431, green: 0.447, blue: 0.506)
    static let darkBackground = Color(red: 0.071, green: 0.078, blue: 0.110)
    static let darkCard = Color(red: 0.118, green: 0.133, blue: 0.188)

    static let cardShadow = Color.black.opacity(0.10)
    static let cardBorder = Color.white.opacity(0.72)
    static let darkCardBorder = Color.white.opacity(0.08)

    static func cardBackground(darkMode: Bool) -> Color {
        darkMode ? darkCard : .white
    }

    static func textPrimary(darkMode: Bool) -> Color {
        darkMode ? .white : primaryText
    }

    static func textSecondary(darkMode: Bool) -> Color {
        darkMode ? .white.opacity(0.72) : secondaryText
    }

    static var primaryGradient: LinearGradient {
        LinearGradient(
            colors: [primary, purpleAccent],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    static var blueGradient: LinearGradient {
        LinearGradient(
            colors: [blueAccent, Color(red: 0.494, green: 0.843, blue: 1.0)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    static var greenGradient: LinearGradient {
        LinearGradient(
            colors: [greenSuccess, Color(red: 0.514, green: 0.945, blue: 0.773)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    static func brandGradient(colorblindMode: Bool) -> LinearGradient {
        LinearGradient(
            colors: colorblindMode
                ? [goldReward, blueAccent, primary]
                : [primary, purpleAccent, blueAccent],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    static func subjectColor(for subjectID: String, colorblindMode: Bool = false) -> Color {
        if colorblindMode {
            switch subjectID {
            case "algebra":
                return primary
            case "reading":
                return .orange
            case "biology":
                return .teal
            case "programming-fundamentals":
                return .indigo
            default:
                return primary
            }
        }

        switch subjectID {
        case "algebra":
            return primary
        case "reading":
            return blueAccent
        case "biology":
            return greenSuccess
        case "programming-fundamentals":
            return purpleAccent
        default:
            return primary
        }
    }
}

extension Font {
    static func studyQuest(_ style: Font.TextStyle, weight: Font.Weight = .regular) -> Font {
        .system(style, design: .rounded).weight(weight)
    }
}

extension View {
    func studyQuestCard(settings: AppAccessibilitySettings, radius: CGFloat = AppTheme.cardRadius) -> some View {
        self
            .background(AppTheme.cardBackground(darkMode: settings.darkMode))
            .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .stroke(settings.darkMode ? AppTheme.darkCardBorder : AppTheme.cardBorder, lineWidth: 1)
            )
            .shadow(color: settings.darkMode ? .clear : AppTheme.cardShadow, radius: 20, x: 0, y: 8)
    }
}
