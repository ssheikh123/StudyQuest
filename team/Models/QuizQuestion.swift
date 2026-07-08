import Foundation

struct QuizQuestion: Identifiable, Hashable {
    let id: String
    let prompt: String
    let answers: [QuizAnswer]
    let hints: [String]

    init(id: String = UUID().uuidString, prompt: String, answers: [QuizAnswer], hints: [String] = []) {
        self.id = id
        self.prompt = prompt
        self.answers = answers
        self.hints = hints
    }

    var correctAnswerID: String? {
        answers.first(where: \.isCorrect)?.id
    }
}
