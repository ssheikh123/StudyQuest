import Foundation

struct QuizAnswer: Identifiable, Hashable {
    let id: String
    let title: String
    let isCorrect: Bool

    init(id: String = UUID().uuidString, title: String, isCorrect: Bool = false) {
        self.id = id
        self.title = title
        self.isCorrect = isCorrect
    }
}
