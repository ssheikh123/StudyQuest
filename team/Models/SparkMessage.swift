import Foundation

enum SparkMessageRole: String, Codable {
    case student
    case spark
}

struct SparkMessage: Identifiable, Codable, Equatable {
    let id: UUID
    let role: SparkMessageRole
    let text: String
    let date: Date

    init(id: UUID = UUID(), role: SparkMessageRole, text: String, date: Date = Date()) {
        self.id = id
        self.role = role
        self.text = text
        self.date = date
    }
}
