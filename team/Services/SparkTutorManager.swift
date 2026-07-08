import Foundation

protocol SparkTutorProviding {
    func response(to message: String, context: LessonContext?, conversation: SparkConversation) async -> String
}

struct LocalSparkTutorProvider: SparkTutorProviding {
    func response(to message: String, context: LessonContext?, conversation: SparkConversation) async -> String {
        let normalized = message.lowercased()
        let lessonPhrase = context.map { " in \($0.lessonTitle)" } ?? ""

        if asksForAnswer(normalized) {
            return "I'll help you get there, but I won't give away the answer. Let's start with the first step: what clue in the question seems most important?"
        }

        if normalized.contains("hint") || normalized.contains("first step") {
            return "Here's a hint\(lessonPhrase): look for the key idea first, then eliminate choices that don't match it. What does the question ask you to find?"
        }

        if normalized.contains("another way") || normalized.contains("don't understand") || normalized.contains("dont understand") {
            return explanation(for: context)
        }

        if normalized.contains("quiz") || normalized.contains("practice") || normalized.contains("problem") {
            return "Let's practice! Try this: explain the main idea in your own words, then choose one detail that supports it. No XP here, just practice treasure."
        }

        if normalized.contains("variable") || context?.lessonTitle.lowercased().contains("variable") == true {
            return "A variable is like a labeled box. We may not know what's inside yet, but clues in the problem help us figure it out. What operation is happening to the variable?"
        }

        return "Let's soar through this together. Tell me what part feels tricky, and I'll help with a hint or a simpler example."
    }

    private func asksForAnswer(_ text: String) -> Bool {
        text.contains("tell me the answer") || text.contains("just give") || text.contains("answer key") || text.contains("solve it for me") || text.contains("what is the answer")
    }

    private func explanation(for context: LessonContext?) -> String {
        guard let context else {
            return "Let's make it simpler. Break the problem into one small question: what do you already know, and what are you trying to find?"
        }

        switch context.subject.lowercased() {
        case "algebra":
            return "For Algebra, think of each problem like balancing a scale. Do the same kind of move to both sides, and try to isolate the unknown step by step."
        case "reading":
            return "For Reading, start by asking: what is the text mostly saying? Then use details from the passage as clues."
        case "biology":
            return "For Biology, connect the vocabulary to a real living system. Ask what job each part does and how it helps the organism survive."
        case "programming fundamentals":
            return "For Programming, imagine giving very clear instructions to a robot. Each concept helps the robot store, repeat, choose, or organize information."
        default:
            return "Let's break \(context.lessonTitle) into one idea at a time. What is the question asking you to notice first?"
        }
    }
}

enum SparkTutorManager {
    static func send(_ text: String, conversation: inout SparkConversation, context: LessonContext?, provider: SparkTutorProviding = LocalSparkTutorProvider()) async {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        conversation.messages.append(SparkMessage(role: .student, text: trimmed))
        let response = await provider.response(to: trimmed, context: context, conversation: conversation)
        conversation.messages.append(SparkMessage(role: .spark, text: response))
    }

    static func hint(for question: QuizQuestion, hintIndex: Int, context: LessonContext?) -> String {
        if question.hints.indices.contains(hintIndex) {
            return question.hints[hintIndex]
        }

        switch hintIndex {
        case 0:
            return "Read the question carefully and underline the key idea in your mind."
        case 1:
            return "Look for the answer choice that matches the concept from \(context?.lessonTitle ?? "this lesson")."
        default:
            return "Try eliminating one answer that clearly does not fit, then compare the remaining choices."
        }
    }
}
