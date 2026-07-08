import Foundation

enum LearningPromptBuilder {
    static let suggestedPrompts = [
        "Explain this lesson",
        "Give me a hint",
        "Explain it another way",
        "I don't understand",
        "Try an easier example",
        "Quiz me",
        "What's the first step?"
    ]

    static func systemPrompt(context: LessonContext?) -> String {
        var reminder = "The learning assistant gives hints, examples, and guiding questions. It never reveals final quiz answers or answer keys."
        if let context {
            reminder += " Current lesson: \(context.subject), \(context.lessonTitle), \(context.difficulty.rawValue)."
        }
        return reminder
    }
}
