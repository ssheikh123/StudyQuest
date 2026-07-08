import Foundation

enum SparkPromptBuilder {
    static let suggestedPrompts = [
        "Explain this lesson.",
        "Give me a hint.",
        "Can you explain it another way?",
        "I don't understand.",
        "Can we try an easier example?",
        "Quiz me.",
        "What's the first step?"
    ]

    static func safetyReminder(context: LessonContext?) -> String {
        var reminder = "Spark is a patient tutor. Give hints, examples, and guiding questions. Never reveal final quiz answers or answer keys."
        if let context {
            reminder += " Current lesson: \(context.subject), \(context.lessonTitle), \(context.difficulty.rawValue)."
        }
        return reminder
    }
}
