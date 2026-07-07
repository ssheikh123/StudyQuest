import SwiftUI

struct AppAccessibilitySettings: Codable, Equatable {
    var darkMode = false
    var colorblindMode = false
    var largerText = false
    var textToSpeech = false
    var highContrast = false
    var reduceMotion = false
    var buttonLabels = true

    var accentColor: Color {
        colorblindMode ? .orange : AppTheme.primary
    }

    var screenBackground: Color {
        darkMode ? AppTheme.darkBackground : AppTheme.background
    }

    var alternateScreenBackground: Color {
        darkMode ? AppTheme.darkBackground : AppTheme.background
    }

    var cardBackground: Color {
        AppTheme.cardBackground(darkMode: darkMode)
    }

    var primaryText: Color {
        AppTheme.textPrimary(darkMode: darkMode)
    }

    var secondaryText: Color {
        AppTheme.textSecondary(darkMode: darkMode)
    }
}
