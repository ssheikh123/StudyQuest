import SwiftUI

struct AppAccessibilitySettings {
    var darkMode = false
    var colorblindMode = false
    var largerText = false
    var textToSpeech = false
    var highContrast = false
    var reduceMotion = false
    var buttonLabels = true

    var accentColor: Color {
        colorblindMode ? .orange : .purple
    }

    var screenBackground: Color {
        darkMode ? .black : Color(red: 0.96, green: 0.97, blue: 1.0)
    }

    var alternateScreenBackground: Color {
        darkMode ? .black : Color(red: 0.95, green: 0.98, blue: 0.97)
    }

    var cardBackground: Color {
        darkMode ? Color(red: 0.04, green: 0.04, blue: 0.05) : Color(.secondarySystemGroupedBackground)
    }
}
