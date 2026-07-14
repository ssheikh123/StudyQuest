import SwiftUI

struct AppAccessibilitySettings: Codable, Equatable {
    var darkMode = false
    var colorblindMode = false
    var largerText = false
    var textToSpeech = false
    var highContrast = false
    var reduceMotion = false
    var buttonLabels = true
    var enableHaptics = true
    var enableSounds = true

    enum CodingKeys: String, CodingKey {
        case darkMode
        case colorblindMode
        case largerText
        case textToSpeech
        case highContrast
        case reduceMotion
        case buttonLabels
        case enableHaptics
        case enableSounds
    }

    init() { }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        darkMode = try container.decodeIfPresent(Bool.self, forKey: .darkMode) ?? false
        colorblindMode = try container.decodeIfPresent(Bool.self, forKey: .colorblindMode) ?? false
        largerText = try container.decodeIfPresent(Bool.self, forKey: .largerText) ?? false
        textToSpeech = try container.decodeIfPresent(Bool.self, forKey: .textToSpeech) ?? false
        highContrast = try container.decodeIfPresent(Bool.self, forKey: .highContrast) ?? false
        reduceMotion = try container.decodeIfPresent(Bool.self, forKey: .reduceMotion) ?? false
        buttonLabels = try container.decodeIfPresent(Bool.self, forKey: .buttonLabels) ?? true
        enableHaptics = try container.decodeIfPresent(Bool.self, forKey: .enableHaptics) ?? true
        enableSounds = try container.decodeIfPresent(Bool.self, forKey: .enableSounds) ?? true
    }

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
