import SwiftUI

struct Lesson: Identifiable {
    let id: String
    let subjectID: String
    let subjectTitle: String
    let title: String
    let difficulty: LessonDifficulty
    let order: Int
    let iconName: String
    let color: Color
    let introduction: String
    let explanation: String
    let workedExample: String
    let quizQuestions: [QuizQuestion]
    let xpReward: Int
    let badgeProgress: Int
    let estimatedTime: String

    func displayColor(colorblindMode: Bool) -> Color {
        colorblindMode ? Lesson.colorblindColor(for: subjectID) : color
    }

    static func colorblindColor(for subjectID: String) -> Color {
        AppTheme.subjectColor(for: subjectID, colorblindMode: true)
    }
}
