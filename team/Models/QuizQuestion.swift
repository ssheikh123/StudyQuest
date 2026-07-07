import Foundation

struct QuizQuestion: Identifiable, Hashable {
    let id: String
    let prompt: String
    let answers: [QuizAnswer]

    init(id: String = UUID().uuidString, prompt: String, answers: [QuizAnswer]) {
        self.id = id
        self.prompt = prompt
        self.answers = answers
    }

    var correctAnswerID: String? {
        answers.first(where: \.isCorrect)?.id
    }
}
