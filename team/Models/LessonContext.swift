import Foundation

struct LessonContext: Codable, Equatable {
    let lessonID: String
    let subject: String
    let lessonTitle: String
    let difficulty: LessonDifficulty
    let learningObjectives: [String]
    let lessonExplanation: String
    let workedExamples: [String]
    let hintText: [String]
    let quizTopics: [String]
    let keywords: [String]

    init(lesson: Lesson) {
        lessonID = lesson.id
        subject = lesson.subjectTitle
        lessonTitle = lesson.title
        difficulty = lesson.difficulty
        learningObjectives = [
            "Understand the main idea of \(lesson.title).",
            "Apply the lesson idea to a short practice problem.",
            "Explain the reasoning in your own words."
        ]
        lessonExplanation = [lesson.introduction, lesson.explanation]
            .filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
            .joined(separator: "\n\n")
        workedExamples = [lesson.workedExample].filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
        hintText = lesson.quizQuestions.flatMap(\.hints)
        quizTopics = lesson.quizQuestions.map(\.prompt)
        keywords = LessonContext.keywords(from: lesson)
    }

    var compactDescription: String {
        "\(subject) • \(lessonTitle) • \(difficulty.rawValue)"
    }

    var currentObjective: String {
        learningObjectives.first ?? "Understand \(lessonTitle)."
    }

    private static func keywords(from lesson: Lesson) -> [String] {
        let source = [lesson.subjectTitle, lesson.title, lesson.introduction, lesson.explanation]
            .joined(separator: " ")
            .lowercased()
        let separators = CharacterSet.alphanumerics.inverted
        let words = source.components(separatedBy: separators).filter { $0.count > 4 }

        var seen = Set<String>()
        return words.compactMap { word in
            guard !seen.contains(word) else { return nil }
            seen.insert(word)
            return word
        }
        .prefix(12)
        .map { $0 }
    }
}
