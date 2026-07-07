import SwiftUI

enum AppTheme {
    static let cornerRadius: CGFloat = 8
    static let cardRadius: CGFloat = 28
    static let buttonRadius: CGFloat = 24
    static let fieldRadius: CGFloat = 18
    static let dashboardCornerRadius: CGFloat = cardRadius

    static let background = Color(red: 0.965, green: 0.973, blue: 0.988)
    static let primary = Color(red: 0.31, green: 0.49, blue: 0.953)
    static let purpleAccent = Color(red: 0.545, green: 0.427, blue: 1.0)
    static let greenSuccess = Color(red: 0.337, green: 0.827, blue: 0.392)
    static let goldReward = Color(red: 1.0, green: 0.784, blue: 0.341)
    static let coral = Color(red: 1.0, green: 0.478, blue: 0.478)
    static let primaryText = Color(red: 0.11, green: 0.11, blue: 0.118)
    static let secondaryText = Color(red: 0.431, green: 0.431, blue: 0.451)
    static let darkBackground = Color(red: 0.055, green: 0.059, blue: 0.075)
    static let darkCard = Color(red: 0.11, green: 0.118, blue: 0.145)

    static let cardShadow = Color.black.opacity(0.08)

    static func cardBackground(darkMode: Bool) -> Color {
        darkMode ? darkCard : .white
    }

    static func textPrimary(darkMode: Bool) -> Color {
        darkMode ? .white : primaryText
    }

    static func textSecondary(darkMode: Bool) -> Color {
        darkMode ? .white.opacity(0.72) : secondaryText
    }

    static func brandGradient(colorblindMode: Bool) -> LinearGradient {
        LinearGradient(
            colors: colorblindMode
                ? [goldReward, Color.teal, primary]
                : [primary, purpleAccent, Color(red: 0.38, green: 0.79, blue: 1.0)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    static func subjectColor(for subjectID: String, colorblindMode: Bool = false) -> Color {
        if colorblindMode {
            switch subjectID {
            case "algebra":
                return .indigo
            case "reading":
                return .orange
            case "biology":
                return .teal
            case "programming-fundamentals":
                return .purple
            default:
                return primary
            }
        }

        switch subjectID {
        case "algebra":
            return primary
        case "reading":
            return .orange
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
            .clipShape(RoundedRectangle(cornerRadius: radius))
            .shadow(color: settings.darkMode ? .clear : AppTheme.cardShadow, radius: 18, x: 0, y: 10)
    }
}
