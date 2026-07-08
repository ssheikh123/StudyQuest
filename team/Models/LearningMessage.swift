import Foundation

enum LearningMessageRole: String, Codable {
    case student
    case assistant
}

struct LearningMessage: Identifiable, Codable, Equatable {
    let id: UUID
    let role: LearningMessageRole
    let text: String
    let date: Date

    init(id: UUID = UUID(), role: LearningMessageRole, text: String, date: Date = Date()) {
        self.id = id
        self.role = role
        self.text = text
        self.date = date
    }
}
